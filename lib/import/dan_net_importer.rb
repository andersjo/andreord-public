#coding: utf-8
require 'fileutils'

module Import
  class DanNetImporter
    extend ActiveSupport::Memoizable
    #include Hirb::Console
    DATA_DIR = "#{RAILS_ROOT}/lib/import/dan_net_data"
    DATA_FILE = "#{DATA_DIR}/dannet.zip"
    DATA_URL = "http://wordnet.dk/dannet/DanNet-1.4_csv.zip"
    UNITS = %w{synsets dummies synset_attributes words wordsenses relations}

    REVERSE_RELATIONS = { 'holo' => 'mero', 'hypero' => 'hypo',
      'mero' => 'holo', 'hypo'   => 'hypero'}

    def initialize
      @connection = ActiveRecord::Base.connection
    end

    def run
      steps = [
        :download_file,
        :create_mapping_table,
        :truncate_tables,
        :import_files,
        :drop_mapping_table,
        :register_reverse_relation_types,
        :symmetize_reverse_relations,
        :generate_word_sense_headings,
        :generate_word_parts,
      ]
      ActiveRecord::Base.transaction do
        steps.each do |step|
          puts "running '#{step}' ... "
          send(step)
        end
      end
    end

    def import_files
      UNITS.each do |unit|
        @unit = unit
        puts "\timport_'#{unit}' ... "
        send("import_#{unit}")
      end
    end

    def create_mapping_table
      run_sql <<SQL
      CREATE TABLE word_sense_mappings AS
        SELECT id, word_id, syn_set_id
        FROM word_senses
SQL

      run_sql <<SQL
      CREATE INDEX word_sense_mappings_syn_set_id_and_word_id
      ON word_sense_mappings (syn_set_id, word_id)
SQL
    end

    def drop_mapping_table
      run_sql "DROP TABLE word_sense_mappings"
    end

    def truncate_tables
      tables = %w{ddo_mappings feature_types features relation_types relations syn_sets word_parts word_senses words}
      tables.each do |table|
        run_sql "TRUNCATE #{table} CASCADE"
      end
    end

    def import_synsets
      #  id:    Id of synset. This id will remain constant in future versions
      #         of DanNet.
      #  label: Name of synset based on the word forms linked to this synset.
      #         It is only intended as a convenience for the user. For
      #         information about the lexical forms, please refer to words.csv.
      #  gloss: Gloss of the synsets. Consists of a small part of the definition
      #         from the Danish Dictionary plus hand-selected examples from the
      #         corpus.
      #  ontological_type: Ontological type of the synset, e.g. 'Comestible'
      #         or 'Vehicle+Object+Artifact'.
      rows(%w{id label gloss ontological_type}) do |row|
        next unless local_synset_id?(row['id'])
        syn_set = DanNet::SynSet.new(:label => row['label'])
        if row['gloss'] =~ /^(.*)(\s*\(Brug:\s"(.*))"\)/
          syn_set.gloss = $1
          syn_set.usage = $3
        else
          syn_set.gloss = row['gloss']
        end
        syn_set.id = convert_hyphened_id(row['id'])
        syn_set.save!

        type_names = row['ontological_type'].gsub(/[\(\)]/, '').split("+")
        type_names.each do |type_name|
          syn_set.features.create!(:feature_type => feature_type_by_name(type_name))
        end
      end
    end

    def import_dummies
      #  The dummies file has exactly the same structure as the synsets
      #  file. But synsets in this file are not supplied with any
      #  relations in this version of DanNet.
      #  NOTE: This description does not seem to hold for DanNet 1.0.1.
      #        Several relations depend on synsets defined in dummies

      import_synsets
    end

    def import_synset_attributes

    end

    def import_words
      #  id:    Id for the lexical entry. This will be stable through future
      #         versions of DanNet. However, for some id's a number has been
      #         appended to the core id with a hyphen (e.g. '...-1'. This part
      #         of the id might unfortunately in rare cases change in future
      #         releases, while the core part will be stable.
      #  form:  The lexical form of the entry
      #  pos:   The part of speech of the entry
      rows(%w{id form pos}) do |row|
        word = DanNet::Word.new(
          :lemma => row['form'],
          :pos_tag => pos_tag_by_name(row['pos']))
        word.id = convert_hyphened_id(row['id'])
        word.save!
      end
    end

    def import_wordsenses
      #  wordsense_id:   Id of the word sense
      #  word_id:   Id of the lexical entry (in the words.csv file)
      #  synset_id: Id of the synset (in the synsets.csv file)
      #  register:  Some word senses may be marked as non-standard, e.g.
      #             'sj.' for seldomly used, 'gl.' for old-fashionable,
      #             or 'slang'.
      #             In general, if a value is present for a word sense in
      #             this column, it may be regarded as non-standard use.
      rows(%w{ddo_id word_id synset_id register}) do |row|
        # We need to check if a word sense with the word_id and synset_id
        # specified by the row already exists. If not, false word senses
        # will be created. This is caused by the column ddo_id which we will
        # need to handle seperately
        next unless local_synset_id?(row['synset_id'])
        key_columns = {
          :word_id     => convert_hyphened_id(row['word_id']),
          :syn_set_id  => convert_hyphened_id(row['synset_id']) }
        ws = DanNet::WordSense.first(:conditions => key_columns)
        if not ws
          ws = DanNet::WordSense.new(key_columns.merge({:register => row['register']}))
          ws.assume_id_from_mapping_table!
          ws.save!
        end
        DanNet::DdoMapping.create!(:ddo_id => row['ddo_id'], :word_sense => ws)
      end
    end

    def import_relations
      #  synset_id: Id of the synset is described by the relation.
      #  name:      The name of the relation (in wordnet/owl terminology)
      #  name2:     the name of the relation (i EuroWordNet terminology)
      #  value:     The target of the relation. The Value is always an id
      #             of a synset (in the synsets.csv file), a dummy (in
      #             the dummies.csv file), or a Princeton Wordnet synset.
      #  taxonomic: Possible values: 'taxonomic' or 'nontaxonomic'
      #             Distinguishes between taxonomic and nontaxonomic
      #             hyponymy, cf. the specifications for DanNet
      #             (http://wordnet.dk/download_html). Available only in
      #             Danish. Only relevant for the hyponymOf relation.
      #  inheritance_comment: A synset inherits relations from hypernyms
      #             If a relation is inherited rather than supplied for the
      #             particular synset, a text comment will state from which
      #             synset the relation stems.
      rows(%w{synset_id name name2 value taxonomic inheritance_comment}) do |row|
        next unless local_synset_id?(row['synset_id'])
        rel = DanNet::Relation.new
        if row['value'] =~ /^ENG/
          rel.target_word_net_id = row['value']
        else
          next unless local_synset_id?(row['value'])
          rel.target_syn_set_id = convert_hyphened_id(row['value'])
        end
        if row['taxonomic'].present?
          rel.taxonomic = !!(row['taxonomic'] == 'taxonomic')
        end

        rel.syn_set_id = convert_hyphened_id(row['synset_id'])
        rel.relation_type = relation_type_by_name(row['name2'], row['name'])
        rel.inheritance_comment = row['inheritance_comment'] unless row['inheritance_comment'].blank?
        rel.save!
      end
      DanNet::SynSet.define_relation_methods
    end

    def register_reverse_relation_types
      rel_type_map = DanNet::RelationType.all.index_by(&:name)
      rel_type_map.values.each do |rel_type|
        REVERSE_RELATIONS.find do |from,to|
          next unless rel_type.name.include? from
          rel_type.reverse = rel_type_map[rel_type.name.gsub(from,to)]
        end
      end
      rel_type_map.values.each(&:save!)
    end

    def symmetize_reverse_relations
      DanNet::RelationType.all.each do |rel_type|
        insert_missing_relations_for rel_type if rel_type.reverse
      end
    end

    def insert_missing_relations_for(relation_type)
      sql = <<SQL
        INSERT INTO relations
          (relation_type_id, syn_set_id, target_syn_set_id, taxonomic)

          SELECT reverse_id, target_syn_set_id, syn_set_id, taxonomic
          FROM
          ( -- All relations the reverse type; candidates for insertion
            SELECT r.syn_set_id, r.target_syn_set_id, rt.reverse_id, r.taxonomic
              FROM relations r
                JOIN relation_types rt
                  ON r.relation_type_id = rt.id
              WHERE rt.id = #{relation_type.reverse_id}
                AND r.target_syn_set_id IS NOT NULL
            -- Eliminate relations already defined
            EXCEPT
              -- target and base are swapped
              SELECT r.target_syn_set_id, r.syn_set_id, rt.id, r.taxonomic
              FROM relations r
                JOIN relation_types rt
                  ON r.relation_type_id = rt.id
              WHERE rt.id = #{relation_type.id}
                AND r.target_syn_set_id IS NOT NULL) missing
SQL

      conn = ActiveRecord::Base.connection
      conn.execute(sql)
    end

    def generate_word_sense_headings
      senses_for_lemma = []
      prev_lemma = nil
      DanNet::Word.all(
        :include => [:word_senses],
        :order => 'words.lemma').each do |w|

        if prev_lemma != w.lemma and prev_lemma.present?
          generate_headings_and_save(senses_for_lemma)
        end
        senses_for_lemma += w.word_senses
        prev_lemma = w.lemma
      end
      generate_headings_and_save(senses_for_lemma)
    end

    def generate_headings_and_save(senses_for_lemma)
      DanNet::WordSense.distinct_headings(senses_for_lemma)
      senses_for_lemma.each(&:save!)
      senses_for_lemma.clear
    end

    def generate_word_parts
      sql = %{
        INSERT INTO word_parts
          SELECT w1.id, w2.id
          FROM words w1
            JOIN words w2
              ON w2.lemma LIKE '%'||w1.lemma||'%'
      }
      conn = ActiveRecord::Base.connection
      conn.execute(sql)
    end

    def pos_tag_by_name(name)
      DanNet::PosTag.find_or_create_by_name(name)
    end
    memoize :pos_tag_by_name
    
    def feature_type_by_name(name)
      DanNet::FeatureType.find_or_create_by_name(name)
    end
    memoize :feature_type_by_name

    def relation_type_by_name(name, alt_name)
      unless rel_type = DanNet::RelationType.find_by_name(name)
        rel_type = DanNet::RelationType.create!(
          :name => name,
          :word_net_name => alt_name)
      end
      rel_type
    end
    memoize :relation_type_by_name

    def file_content
      begin
        file = File.open("#{DATA_DIR}/#{@unit}.csv", "r")
        Iconv.conv("UTF-8", "ISO-8859-1", file.read)
      ensure
        file.close
      end
    end

    def rows(header)
      file_content.each_line do |line|
        h={}
        header.zip(line.split("@")).each {|k,v|
          h[k] = v
        }
        begin
          yield h
        rescue Exception => e
          puts "While processing:"
          puts "\t#{h.inspect}"
          puts "\t#{line}"
          raise e
        end
      end
    end

    # convert strings like 1234-5 to larger integers resembling 1234005
    def convert_hyphened_id(str)
      str =~ /(\d+)(-(\d+))?/ or raise "invalid id: #{str}"
      $1.to_i * 1000 + $3.to_i
    end

    def download_file
      FileUtils.mkdir DATA_DIR unless File.exists? DATA_DIR
      Dir.chdir DATA_DIR
      unless File.exists?(DATA_FILE)
        cmd "curl #{DATA_URL} > #{DATA_FILE}"
        cmd "unzip -d extracted #{DATA_FILE}"
        Dir.glob("#{DATA_DIR}/extracted/**/*").each do |file|
          unless File.directory?(file)
            FileUtils.mv file, "#{DATA_DIR}/#{File.basename(file)}"
          end
        end
        cmd "rm -rf extracted"
      end
    end

    def cmd(cmd, comment = "")
      msg = "#{cmd}"
      msg = "#{comment}: #{msg}" if comment.present?
      puts msg
      out = `#{cmd}`
      raise "Fejl ved '#{cmd}': #{error}" if $? != 0
    end

    def run_sql(sql)
      @connection.execute sql
    end

    def local_synset_id?(id)
       id =~ /^[0-9]+$/
    end

    def self.import
      DanNetImporter.new.run
    end

  end
end
