#coding: utf-8
module DanNet
  class SynSet < ActiveRecord::Base
    has_many :words, :through => :word_senses
    has_many :relations, {:class_name=>"DanNet::Relation", :foreign_key=>"syn_set_id" }
    has_many :alignments
    has_many :relation_types, :through => :relations
    has_many :word_senses, {:class_name=>"DanNet::WordSense"} do

      def preferred
        detect do |ws|
          preferred_word = I18n.t(ws.syn_set_id , :scope => 'pretty_labels', :default => 'XXX')
          ws.heading.start_with? preferred_word
        end or first
      end
    end
    has_many :features, {:class_name => 'DanNet::Feature'} do
      
      def signature
        map(&:name).sort*'+'
      end
    end
    accepts_nested_attributes_for :word_senses

    def pretty_label
      begin
        I18n.t id, 
          :scope => 'pretty_labels',
          :raise => true
      rescue I18n::MissingTranslationData
        cleaned_label
      end
    end

    def examples
      (usage||'').split(/ [|][|] |;\s*/).map do |example|
        clean_unmatched_quotation_marks(example)
      end
    end

    def top?
      label == "{DN:TOP}"
    end

    def internal?
      label =~ /^\{DN:(TOP|abstract_entity|1stOrder|2ndOrder|VERB)/
    end

    def paths_to_top(exclude_internal=true)
      paths_to_top_recursive.collect {|path|
        path[1..-1].select {|syn_set|
          exclude_internal ? !syn_set.internal? : true
        }
      }
    end

    # private
    def paths_to_top_recursive(visited = Set.new)
      return [[self]] if top?
      paths = []
      hyperonyms.each {|h|
        next if visited.include? h # at present, the tree has several nodes with self reference
        visited << h
        h.paths_to_top_recursive(visited).each {|path|
          paths << path.unshift(self)
        }
      }
      paths
    end

    def hyponyms_below(max_level = 4, min_count = 2)
      rel_hyponym_id = RelationType.find_by_name("has_hyponym").id
      sql = """
WITH RECURSIVE t(level,id,parent_id) as (
          VALUES (0,#{id}::bigint,NULL::bigint)
        UNION ALL
          SELECT t.level+1, r.target_syn_set_id, r.syn_set_id
          FROM t, relations r
          JOIN syn_sets s
            ON r.target_syn_set_id = s.id
          WHERE r.syn_set_id = t.id
            AND r.relation_type_id = #{rel_hyponym_id}
            AND t.level <= #{max_level.to_i-1}
            AND s.hyponym_count >= #{min_count.to_i}
      )
      SELECT s.id, s.label, t.parent_id, s.hyponym_count, t.level
        FROM t
        JOIN syn_sets s
          ON t.id = s.id
      """
      HyponymTree.new(SynSet.find_by_sql(sql))
    end

    def shortest_path_to(dst)
      rg = RelationsGraph.new
      path_ids = rg.shortest_path_between(self.id, dst.id)
      if path_ids # fetch records in one go
        steps = SynSet.find(path_ids).index_by(&:id)
        path_ids.collect do |step_id|
          steps[step_id]
        end
      else
        nil
      end
    end

    def depth
      parents.to_a.size
    end

    def avg_height
      heights = hyponyms.map(&:avg_height)
      if heights.size > 0
        (heights.sum / heights.size) + 1.0
      else
        0.0
      end
    end

    def cleaned_label
      case label
      when /:\s*([^;}]+)/ then $1
      when /\{([^_,]+)/ then $1
      end
    end

    def parents
      return enum_for(:parents) unless block_given?
      me = self
      yield me while me = me.hyperonym
    end

    def sister_terms
      hyperonym and hyperonym.hyponyms or []
    end

    def related_syn_sets_in_groups(max_per_group = 100)
      groups = {}
      rel_types = DanNet::RelationType.for_syn_set(self)
      rel_types.each do |rel_type|
        relations = with_relation(rel_type.name, max_per_group)
        groups[rel_type] = relations unless relations.empty?
      end
      groups
    end

    def with_relation(name, limit = nil)
      rels = Relation.all(
        :conditions => ['relation_types.name = ? AND relations.syn_set_id = ?', name, self],
        :include => [:relation_type],
        :limit => limit)
      SynSet.find( rels.map(&:target_syn_set_id).compact,
        :include => [:word_senses, :words])
    end

    def self.define_relation_methods
      RelationType.all.each do |rel_type|
        meth_name = rel_type.name.gsub("has_", "")
        define_method(meth_name.pluralize) {
          with_relation(rel_type.name)
        }
        define_method(meth_name) {
          with_relation(rel_type.name).first
        }
      end
    end
    define_relation_methods

    def clean_unmatched_quotation_marks(text)
      if text.scan(/"/).length == 1
        text.gsub('"', '')
      else
        text
      end
    end

  end
end
