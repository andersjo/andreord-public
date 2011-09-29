#coding: utf-8
module DanNet
  class RelationType < ActiveRecord::Base
    belongs_to :reverse, :foreign_key => 'reverse_id', :class_name => 'DanNet::RelationType'

    def self.for_syn_set(syn_set)
      ids = DanNet::Relation.find(:all,
        :select => 'relation_type_id',
        :conditions => {:syn_set_id => syn_set},
        :group => 'relation_type_id').map(&:relation_type_id)
      RelationType.find(ids)
    end
  end
end
