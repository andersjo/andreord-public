#coding: utf-8
module DanNet
  class Relation < ActiveRecord::Base
    belongs_to :relation_type
    belongs_to :syn_set
    belongs_to :target_syn_set, :class_name => 'DanNet::SynSet', :foreign_key => 'target_syn_set_id'
    
    def self.relations_for_path(path)
      path.each_cons(2).collect do |base,target|
        find(:first, :conditions => 
            { :syn_set_id => base, 
              :target_syn_set_id => target})
      end
    end

    def self.rows_for_graph
      connection.select_all(<<SQL
        SELECT *
        FROM #{table_name}
        WHERE target_syn_set_id IS NOT NULL
          AND target_syn_set_id NOT IN(20633000)
          AND syn_set_id NOT IN(20633000)
SQL
        )

    end

    def inspect
      "#{syn_set.label} => #{relation_type.name} => #{target_syn_set.label}"
    end
  end
end
