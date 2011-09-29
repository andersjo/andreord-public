#coding: utf-8
module DanNet
  class WordSense < ActiveRecord::Base
    belongs_to :syn_set
    belongs_to :word
    
    attr_accessor :heading_cands

    named_scope(:with_lemma, lambda {|lemma|
      { :conditions => ['words.lemma = ?', lemma],
        :include => [:word]
      }
    })

    def to_param
      "#{id}-#{heading.to_url}"
    end

    def synonyms
      syn_set.word_senses.reject {|ws| ws.id == id }
    end

    def assume_id_from_mapping_table!
      mapping = WordSenseMapping.first(
        :conditions => {  :word_id => word_id,
                          :syn_set_id => syn_set_id })
      self.id = mapping.id if mapping
    end

    def after_initialize
      @heading_cands = []
    end

    def self.test_distinct_headings
      # 11001499000 Amazone
      # 11001622000 analfabet
      senses = [12008440000].collect {|word_id|
        Word.find(word_id).word_senses
      }.flatten
      WordSense.distinct_headings(senses)
    end

    def self.distinct_headings(word_senses)
      discriminators = [
        lambda {|ws| ws.syn_set.hyperonyms.map(&:pretty_label).reject {|label|
            label == ws.syn_set.pretty_label }
        },
        lambda {|ws|
          hypo = ws.syn_set.hyponyms.collect {|hypo| "fx #{hypo.pretty_label}" }
        },
        lambda {|ws| ws.syn_set.with_relation('role_agent').map(&:pretty_label) },
        lambda {|ws| ws.syn_set.with_relation('concerns').map(&:pretty_label) },
        lambda {|ws| I18n.t(ws.word.pos_tag.name).to_s.downcase }
      ]
      word_senses.each {|ws| ws.heading = nil }
      discriminate(discriminators, word_senses) if word_senses.size > 1
      word_senses.each do |ws|
        if ws.heading
          ws.heading = "(#{ws.heading})" unless ws.heading =~ /^\d+$/
          ws.heading = "#{ws.word.lemma} #{ws.heading}"
        else
          ws.heading = ws.word.lemma
        end
      end
    end

    # Sets WordSense.heading with first matching
    # uniquely discriminating string
    def self.discriminate(discriminators, word_senses)
      candidate_map = Hash.new(0)
      discriminators.each do |disc|
        find_candidate_strings(word_senses, disc, candidate_map)
        mark_distinct_candidates(word_senses, candidate_map)
      end
      enumerate_ambigious(word_senses, candidate_map)
    end

    def self.find_candidate_strings(word_senses, disc, candidate_map)
      word_senses.each do |ws|
        cands = [*disc.call(ws)]
        cands.each {|cand| candidate_map[cand] += 1 }
        ws.heading_cands += cands
      end
    end
    
    def self.mark_distinct_candidates(word_senses, candidate_map)
      word_senses.each do |ws|
        ws.heading = ws.heading_cands.find do |cand|
          candidate_map[cand] == 1
        end
      end
    end

    def self.enumerate_ambigious(word_senses, candidate_map)
      ambigious = word_senses.reject(&:heading)
      return if ambigious.empty?
      if ambigious.length == word_senses.length
        common_cands = []
      else
        common_cands = ambigious.map(&:heading_cands).inject(&:&).reject {|cand|
          candidate_map[cand] != ambigious.length
        }
      end
      label = [common_cands.first].compact
      ambigious.each_with_index do |ws,i|
        ws.heading = (label + [i+1])*' '
      end
    end
  end
end
