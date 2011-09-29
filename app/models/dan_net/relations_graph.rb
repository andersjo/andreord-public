#coding: utf-8
module DanNet
  class RelationsGraph
    Infinity = 1.0/0
    IDX_TO_ID_KEY = "relations_graph_idx_to_id"
    ID_TO_IDX_KEY = "relations_graph_id_to_idx"
    EDGES_KEY     = "relations_graph_edges"

    def shortest_path_between(src_id, dst_id)
      build_cached_graph unless cached_graph_exists?
      path = shortest_path_between_idx(id_to_idx[src_id.to_s], id_to_idx[dst_id.to_s])
      path.collect {|step|
        idx_to_id[step].to_i
      } if path
    end
    
    def find_the_way
      # smed og taske
      s=Time.new
      src = DanNet::SynSet.first(:offset => rand(40299))
      dst = DanNet::SynSet.first(:offset => rand(40299))
      path = shortest_path_between(src.id, dst.id)
      puts "found in #{Time.new-s}"
      if path
        puts print_path(path)
      else
        puts "no path found"
      end
    end

    private
    def cached_graph_exists?
      [idx_to_id, id_to_idx, edges].all?(&:present?)
    end

    def build_cached_graph
      l_edges = []
      l_idx_to_id = []
      l_id_to_idx = Hash.new
      rows = DanNet::Relation.rows_for_graph
      rows.each do |row|
        unless l_id_to_idx[row['target_syn_set_id']]
          l_id_to_idx[row['target_syn_set_id']] = l_idx_to_id.length
          l_idx_to_id.push row['target_syn_set_id']
        end
      end
      rows.each do |row|
        base_idx   = l_id_to_idx[row['syn_set_id']]
        target_idx = l_id_to_idx[row['target_syn_set_id']]
        l_edges[base_idx] = Set.new if l_edges[base_idx].nil?
        l_edges[base_idx] << target_idx
      end
      Rails.cache.write(IDX_TO_ID_KEY, l_idx_to_id)
      Rails.cache.write(ID_TO_IDX_KEY, l_id_to_idx)
      Rails.cache.write(EDGES_KEY, l_edges)
    end

    def idx_to_id
      @idx_to_id ||= Rails.cache.read(IDX_TO_ID_KEY)
    end

    def id_to_idx
      @id_to_idx ||= Rails.cache.read(ID_TO_IDX_KEY)
    end

    def edges
      @edges ||= Rails.cache.read(EDGES_KEY)
    end

    def shortest_path_between_idx(src, dst)
      dist = PriorityQueue.new
      previous = {}
      dist[src] = 0
      visited = Array.new(edges.length)
      while not dist.empty?
        u, dist_u = dist.delete_min
        break if u.nil?
        visited[u] = true
        return unwind_path(src, u, previous) if u == dst
        next if edges[u].nil?
        unvisited_edges(visited, edges[u]).each do |neighbor|
          new_dist = dist_u + 1
          if new_dist < (dist[neighbor]||Infinity)
            dist[neighbor] = new_dist
            previous[neighbor] = u
          end
        end
      end
      nil
    end

    def unvisited_edges(visited, neighbors)
      neighbors.select do |neighbor|
        not visited[neighbor]
      end
    end
    
    def unwind_path(src, u, previous)
      returning(Array.new) do |path|
        while previous[u]
          path.unshift u
          u = previous[u]
        end
        path.unshift src
      end
    end


    def print_path(path)
      rel = nil
      out = path.each_cons(2).collect do |base_id,target_id|
        rel = DanNet::Relation.first(
          :conditions => {  :syn_set_id => base_id,
                            :target_syn_set_id => target_id
                          })

        "#{rel.syn_set.label} (#{rel.relation_type.name})"
      end*" "
      out << " #{rel.target_syn_set.label}"

    end


  end
end
