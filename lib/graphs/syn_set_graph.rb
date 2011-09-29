#coding: utf-8
module Graphs
  class SynSetGraph
    RELS_LIMIT = 5
    def initialize(syn_set)
      @syn_set = syn_set
      setup_graph
      add_relations
    end

    def setup_graph
      @graph = GraphViz::new( "ER",
        :type => "graph",
        :output => "png",
        :use => "neato",
        :overlap => "false",
        :sep => ".15",
        :splines => "true"
      )
      @graph.node[:style] = "filled"
      @graph.node[:fillcolor] = "white"
      @graph.node[:fontcolor] = "#515151"
      @graph.edge[:weight] = "2"
      @graph.edge[:arrowsize] = "0.5"
    end


    def add_relations
      center = @graph.add_node(
        @syn_set.id.to_s,
        :label => @syn_set.pretty_label,
        :fontsize => "16.0",
        :fontname => "Univers LT Std:style=65 Bold",
        :style => "filled",
        :color => "#36332F",
        :fillcolor => "white",
        :fontcolor => "#515151"
      )
      rels = @syn_set.relations
      rels = rels.select {|r| r.target_syn_set.present? }
      rels.group_by(&:relation_type_id).each do |rel_type_id, group|
        rel_type = DanNet::RelationType.find(rel_type_id)
        rel_node = @graph.add_node(
          rel_type.id.to_s,
          :label => I18n.t(DanNet::RelationType.find(rel_type_id).name),
          :fontsize => "9.0",
          :fontname => "Univers LT Std:style=47 Light Condensed Oblique",
          :penwidth => "0",
          :shape => "ellipse"
        )
        if group.size > RELS_LIMIT
          rel_node[:label] += " (#{group.size - RELS_LIMIT} udeladt)"
          group = group.slice(0, RELS_LIMIT)
        end

        e = (center << rel_node)
        e[:arrowsize] = "0.0"
        group.each do |member|
          target_node = @graph.add_node(member.target_syn_set_id.to_s,
            :label => member.target_syn_set.pretty_label,
            :fontsize => "10.0",
            :fontname => "Univers LT Std:style=45 Light"
          )
          rel_node << target_node
        end
      end
    end

    def to_png
      tmp=Tempfile.open("syn_set_graph")
      begin
        @graph.output(:output => "png", :file => tmp.path)
        File.open(tmp.path, "r:binary").read
      ensure
        tmp.unlink
      end
    end

  end
end
