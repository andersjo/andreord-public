#coding: utf-8
module DanNet
  class WordSenseGraph
    attr_accessor :word_sense, :syn_set

    def initialize(word_sense)
      @word_sense = word_sense
      @syn_set = @word_sense.syn_set
    end

    def capped_relation_groups(max_total, max_per_group)
      groups = @syn_set.related_syn_sets_in_groups(max_per_group)
      capped_groups = Hash.new{|h,k| h[k] = [] }
      groups.each do |key,val|
        raise "Pool for #{key.name} is empty. Should not happen" if val.empty?
      end

      catch :limit_reached do
        loop do
          groups.each do |rel_type, pool|
            raise "Pool is empty here #{rel_type.name}" if pool.empty?
            capped_groups[rel_type] << pool.pop
            groups.delete(rel_type) if pool.empty?
            throw :limit_reached if capped_groups.values.map(&:size).sum == max_total
          end
          break if groups.empty?
        end
      end

      capped_groups
    end


    def relation_groups
      rel_types = DanNet::RelationType.for_syn_set(@syn_set)
      rel_types.each do |rel_type|
        yield rel_type, @syn_set.with_relation(rel_type.name, 100)
      end
    end
  end
end
