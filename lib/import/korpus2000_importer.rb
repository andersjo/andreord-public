#coding: utf-8
# coding: UTF-8
require 'base64'
module Import
  class Korpus2000Importer
    extend ActiveSupport::Memoizable

    DATA_DIR    = "#{RAILS_ROOT}/data/korpus2000"
    SEGMENT_DIR = "#{DATA_DIR}/segments"
    SEGMENT_SIZE = 1500

    def initialize
      @sentence_count = 0
      @conn = ActiveRecord::Base.connection
    end

    def import
#      segment_files
      Dir.glob("#{SEGMENT_DIR}/*").each do |file|
        pid = fork do
          @conn.reconnect!
          import_file(file)
        end
        Process.wait(pid)
      end
    end

    def setup_corpus
      @corpus = Corpora::Corpus.find_or_create_by_name "Korpus 2000"
    end

    def import_file(file)
      setup_corpus
      puts "importing #{file}"
      Corpora::Corpus.transaction do
        File.open(file).each_line do |line|
          parse_line(line)
        end
      end
    end

    def parse_line(line)
      case line
      when %r{^<s\s(.*)>}
        attrs = {}
        $1.dup.scan(%r{(\S+)="(\S+)"}) do
          next if $1 == "id"
          attrs[$1] = $2.to_i
        end
        begin_sentence attrs
      when %r{^</s>}
        end_sentence
      when %r{\$([^ ])  \s*  (?:\[\$?(\S+)\])?  \s*  ((?:\S+\s?)+)?}x
        token $1, $2, $3, :symbol
      when %r{^\*}, %r{^<}
        0 # ignore
      when %r{(\S+) \s* (?:\[(\S+)\])? \s* ((?:\S+\s?)+)?}x
        token $1, $2, $3, :word
      end

    end

    def find_or_create_word_form_id(word_str, lemma_str)
      lemma_id = find_or_create_lemma_id(lemma_str)
      word_form = Corpora::WordForm.first(:conditions =>
          { :chars => word_str, :lemma_id => lemma_id })
      if not word_form
        word_form = Corpora::WordForm.create! :chars => word_str, :lemma_id => lemma_id
      end
      word_form.id
    end
    memoize :find_or_create_word_form_id

    def find_or_create_lemma_id(lemma_str)
      Corpora::Lemma.find_or_create_by_chars(lemma_str).id if lemma_str
    end
    memoize :find_or_create_lemma_id

    def find_or_create_tag_id(tag_str)
      Corpora::PosTag.find_or_create_by_name(tag_str).id
    end
    memoize :find_or_create_tag_id

    def tag_id_array(tag_str)
      if tag_str
        tag_strs = tag_str.split(/\s/)
      else
        tag_strs = []
      end
      ids = tag_strs.collect do |tag_str|
        find_or_create_tag_id(tag_str)
      end
      "{%s}" % [ids*',']
    end

    def begin_sentence(attrs)
      @sentence = @corpus.sentences.create!
      @sentence.korpus2000_sentences.create! attrs
    end

    def token(word_str, lemma_str, tag_str, kind)
      @last_position = token_position(kind)
      sql = "INSERT INTO c_tokens (sentence_id, word_form_id, pos_tags, position) " +
             "VALUES (%d,%d,'%s',%d)" %
        [ @sentence.id,
          find_or_create_word_form_id(word_str, lemma_str),
          tag_id_array(tag_str),
          @last_position
        ]
      @conn.execute(sql)
    end
    
    def token_position(kind)
      if @last_position
        case kind
        when :word    then (@last_position - @last_position % 10) + 10
        when :symbol  then @last_position + 1
        end
      else
        case kind
        when :word    then 0
        when :symbol  then 1
        end
      end
    end

    def end_sentence
      @last_position = nil
      @sentence_count += 1
      puts "#{@sentence_count} sætninger"
    end

    def segment_files
      Dir.glob("#{SEGMENT_DIR}/*").each {|file| File.unlink(file) }
      Dir.glob("#{DATA_DIR}/*.txt").each do |file|
        segment_file(file)
      end
    end

    def segment_file(file)
      @sentences = 0
      @segment = nil
      File.open(file, "r:iso-8859-1:utf-8").each_line do |line|
        shift_segment(file) if @sentences % SEGMENT_SIZE == 0
        @sentences += 1 if line =~ %r{^</s}
        @segment << line
      end
    end

    def shift_segment(file)
      @segment.close if @segment
      segment_file = File.basename(file, ".txt") + "_#{@sentences / SEGMENT_SIZE}.txt"
      @segment = File.open("#{SEGMENT_DIR}/#{segment_file}", "w")
      @sentences += 1
    end
 
  end

end
