xml.instruct!
xml.graphml do
  xml.graph(:id => "G", :edgedefault => "directed") do
    root_id = "root_syn_set_#{@graph.syn_set.id}"
    xml.node( :id => root_id,
      :label => @graph.word_sense.word.lemma,
      :gloss => @graph.syn_set.gloss,
      :syns  => @graph.syn_set.words.map(&:lemma)*',')
    xml.key(:id => "k0", 
      :for => "node",
      "attr.name" => "label",
      "attr.type" => "string")
    xml.key(:id => "k1",
      :for => "node",
      "attr.name" => "gloss",
      "attr.type" => "string")
    xml.key(:id => "k2",
      :for => "node",
      "attr.name" => "link",
      "attr.type" => "string")
    xml.key(:id => "k3",
      :for => "node",
      "attr.name" => "syns",
      "attr.type" => "string")
    @graph.relation_groups do |rel_type,syn_sets|
      rel_type_id = "rel_#{rel_type.id}"
      xml.node(:id => rel_type_id, :label =>  I18n.t(rel_type.name))
      xml.edge(:id => "edge_#{root_id}_#{rel_type_id}", :source => root_id, :target => rel_type_id)
      syn_sets.each do |syn_set|
        # Some syn sets does not seem to be associated
        # with any word senses. In that case, we skip them
        next unless syn_set.word_senses.first

        syn_set_id = "syn_set_#{rel_type.name}_#{syn_set.id}"
        xml.node( :id => syn_set_id,
          :gloss => syn_set.gloss,
          :syns  => syn_set.words.map(&:lemma)*',',
          :label => syn_set.pretty_label,
          :link => word_sense_graph_url(syn_set.word_senses.first)
        )
        xml.edge(:id => "edge_#{rel_type_id}_#{syn_set_id}", :source => rel_type_id, :target => syn_set_id)
        #        syn_set.word_senses.each do |ws|
        #          w = ws.word
        #          word_id = "word_#{w.id}"
        #          xml.node( :id => word_id,
        #                    :label => w.lemma,
        #                    :link => word_sense_graph_url(ws))
        #          xml.edge(:id => "edge_#{syn_set_id}_#{word_id}", :source => syn_set_id, :target => word_id)
        #        end
      end
    end
  end
end