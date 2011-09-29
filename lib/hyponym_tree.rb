class HyponymTree
  attr_reader :syn_sets
  def initialize(syn_sets)
    @syn_sets = syn_sets
  end

  def filtered_by_level(radius_by_level, pixels_per_group)
    by_level = @syn_sets.group_by(&:level)
    filtered = by_level.map do |level,ss|
      level = level.to_i
      next ss if level == 0
      below_count = ss.map(&:hyponym_count).sum
      ss.sort_by(&:hyponym_count).reverse.select do |s|
        circumference = radius_by_level[level]*2*Math::PI
        Rails.logger.info([s.pretty_label, (s.hyponym_count.to_f / top_node.hyponym_count), radius_by_level[level], circumference, (s.hyponym_count.to_f / top_node.hyponym_count) * circumference].inspect)
        ((s.hyponym_count.to_f / top_node.hyponym_count) * circumference) > pixels_per_group
      end
    end.flatten
    HyponymTree.new(filtered)
  end

  def top_node
    @top_node ||= @syn_sets.find {|syn_set| syn_set.level.to_i == 0 }
  end

  def tree
    by_parent_id = Hash.new {|h,k| h[k] = [] }
    @syn_sets.each do |syn_set|
      by_parent_id[syn_set.parent_id.to_i] << syn_set
    end
    walk_hypo_tree(top_node, by_parent_id)
  end

  def id_tree(level=tree)
    h = {}
    level.each do |key,val|
      if key == 'rest'
        h[key] = val
      else
        h[key.id] = val.is_a?(Hash) ? id_tree(val) : val.id.to_s
      end
    end
    h
  end

  private
  def walk_hypo_tree(current, by_parent_id)
    level_map = {}
    by_parent_id[current.id].each do |child|
      if by_parent_id.has_key? child.id
        level_map[child] = walk_hypo_tree(child, by_parent_id)
      else
        level_map[child] = child
      end
    end
    other_count = current.hyponym_count - by_parent_id[current.id].map(&:hyponym_count).sum
    level_map['rest'] = other_count if other_count > 0
    level_map
  end

  
end
