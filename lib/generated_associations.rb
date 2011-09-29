module GeneratedAssociations

  Corpora::Corpus.class_eval do 
    has_many :sentences, {:class_name=>"Corpora::Sentence", :foreign_key=>"corpus_id"} unless method_defined?(:sentences)  end

  Corpora::Korpus2000Sentence.class_eval do 
    belongs_to :sentence, {:class_name=>"Corpora::Sentence", :foreign_key=>"sentence_id"} unless method_defined?(:sentence)  end

  Corpora::Lemma.class_eval do 
    has_many :lemma_unigrams, {:class_name=>"Corpora::LemmaUnigram", :foreign_key=>"lemma_id"} unless method_defined?(:lemma_unigrams)
    has_many :tokens, {:class_name=>"Corpora::Token", :foreign_key=>"lemma_id", :order=>:position} unless method_defined?(:tokens)
    has_many :word_forms, {:class_name=>"Corpora::WordForm", :foreign_key=>"lemma_id"} unless method_defined?(:word_forms)  end

  Corpora::LemmaUnigram.class_eval do 
    belongs_to :lemma, {:class_name=>"Corpora::Lemma", :foreign_key=>"lemma_id"} unless method_defined?(:lemma)
    belongs_to :pick, {:class_name=>"Corpora::Pick", :foreign_key=>"pick_id"} unless method_defined?(:pick)  end

  Corpora::Pick.class_eval do 
    has_many :lemma_unigrams, {:class_name=>"Corpora::LemmaUnigram", :foreign_key=>"pick_id"} unless method_defined?(:lemma_unigrams)  end

  Corpora::Sentence.class_eval do 
    belongs_to :corpus, {:class_name=>"Corpora::Corpus", :foreign_key=>"corpus_id"} unless method_defined?(:corpus)
    has_many :korpus2000_sentences, {:class_name=>"Corpora::Korpus2000Sentence", :foreign_key=>"sentence_id"} unless method_defined?(:korpus2000_sentences)
    has_many :tokens, {:class_name=>"Corpora::Token", :foreign_key=>"sentence_id", :order=>:position} unless method_defined?(:tokens)  end

  Corpora::Token.class_eval do 
    belongs_to :lemma, {:class_name=>"Corpora::Lemma", :foreign_key=>"lemma_id"} unless method_defined?(:lemma)
    belongs_to :sentence, {:class_name=>"Corpora::Sentence", :foreign_key=>"sentence_id"} unless method_defined?(:sentence)
    belongs_to :word_form, {:class_name=>"Corpora::WordForm", :foreign_key=>"word_form_id"} unless method_defined?(:word_form)  end

  Corpora::WordForm.class_eval do 
    belongs_to :lemma, {:class_name=>"Corpora::Lemma", :foreign_key=>"lemma_id"} unless method_defined?(:lemma)
    has_many :tokens, {:class_name=>"Corpora::Token", :foreign_key=>"word_form_id", :order=>:position} unless method_defined?(:tokens)  end

  DanNet::DdoMapping.class_eval do 
    belongs_to :word_sense, {:class_name=>"DanNet::WordSense", :foreign_key=>"word_sense_id"} unless method_defined?(:word_sense)  end

  DanNet::Feature.class_eval do 
    belongs_to :feature_type, {:class_name=>"DanNet::FeatureType", :foreign_key=>"feature_type_id"} unless method_defined?(:feature_type)
    belongs_to :syn_set, {:class_name=>"DanNet::SynSet", :foreign_key=>"syn_set_id"} unless method_defined?(:syn_set)  end

  DanNet::FeatureType.class_eval do 
    has_many :features, {:class_name=>"DanNet::Feature", :foreign_key=>"feature_type_id"} unless method_defined?(:features)  end

  DanNet::PosTag.class_eval do 
    has_many :words, {:class_name=>"DanNet::Word", :foreign_key=>"pos_tag_id"} unless method_defined?(:words)  end

  DanNet::Relation.class_eval do 
    belongs_to :relation_type, {:class_name=>"DanNet::RelationType", :foreign_key=>"relation_type_id"} unless method_defined?(:relation_type)
    belongs_to :syn_set, {:class_name=>"DanNet::SynSet", :foreign_key=>"syn_set_id"} unless method_defined?(:syn_set)
    belongs_to :target_syn_set, {:class_name=>"DanNet::SynSet", :foreign_key=>"target_syn_set_id"} unless method_defined?(:target_syn_set)  end

  DanNet::RelationType.class_eval do 
    belongs_to :reverse, {:class_name=>"DanNet::RelationType", :foreign_key=>"reverse_id"} unless method_defined?(:reverse)
    has_many :relations, {:class_name=>"DanNet::Relation", :foreign_key=>"relation_type_id"} unless method_defined?(:relations)
    has_one :relation_type, {:class_name=>"DanNet::RelationType", :foreign_key=>"reverse_id"} unless method_defined?(:relation_type)  end

  DanNet::SynSet.class_eval do 
    has_many :features, {:class_name=>"DanNet::Feature", :foreign_key=>"syn_set_id"} unless method_defined?(:features)
    has_many :relations, {:class_name=>"DanNet::Relation", :foreign_key=>"target_syn_set_id"} unless method_defined?(:relations)
    has_many :word_senses, {:class_name=>"DanNet::WordSense", :foreign_key=>"syn_set_id"} unless method_defined?(:word_senses)  end

  DanNet::Word.class_eval do 
    belongs_to :pos_tag, {:class_name=>"DanNet::PosTag", :foreign_key=>"pos_tag_id"} unless method_defined?(:pos_tag)
    has_many :word_senses, {:class_name=>"DanNet::WordSense", :foreign_key=>"word_id"} unless method_defined?(:word_senses)  end

  DanNet::WordSense.class_eval do 
    belongs_to :syn_set, {:class_name=>"DanNet::SynSet", :foreign_key=>"syn_set_id"} unless method_defined?(:syn_set)
    belongs_to :word, {:class_name=>"DanNet::Word", :foreign_key=>"word_id"} unless method_defined?(:word)
    has_many :ddo_mappings, {:class_name=>"DanNet::DdoMapping", :foreign_key=>"word_sense_id"} unless method_defined?(:ddo_mappings)  end

end
