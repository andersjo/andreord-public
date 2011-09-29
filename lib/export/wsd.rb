# coding: utf-8
require 'set'
def concept_id(syn_set, pos)
  "%s-%s" % [syn_set.id, pos.name.downcase[0]]
end

def dn_dict
  DanNet::Word.select('distinct lemma').map(&:lemma).each do |lemma|
    concepts = Set.new
    DanNet::Word.find_all_by_lemma(lemma).each do |word|
      concepts += word.syn_sets.map do |syn_set|
        concept_id(syn_set, word.pos_tag)
      end
    end
    puts "%s %s" % [lemma.gsub(/\s+/, '_').gsub(/[\P{Alnum}&&[^_-]]/, '').downcase, concepts.to_a*" "]
  end
end

def dn_rels
  DanNet::Relation.where('target_syn_set_id IS NOT NULL').find_each do |rel|
    puts "u:%s v:%s" %
    [ concept_id(rel.syn_set, rel.syn_set.words.first.pos_tag),
      concept_id(rel.target_syn_set, rel.syn_set.words.first.pos_tag)]
  end
end

dn_rels