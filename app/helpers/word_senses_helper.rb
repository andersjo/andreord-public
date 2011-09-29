#coding: utf-8
module WordSensesHelper
  def link_word_sense_lemmas(word_senses)
    word_senses.collect do |ws|
      link_to ws.word.lemma, ord_path(ws)
    end
  end

  def format_path_to_top(path)
    path.map {|syn_set|
      ws = syn_set.word_senses.first
      link_to(syn_set.pretty_label, ord_path(ws))
    }.join(' → ')
  end

  def hyponym_nodes_to_json(syn_sets)
    h = {}
    syn_sets.each do |syn_set|
      extra = {
        'pretty_label' => syn_set.pretty_label,
        'link'         => best_for_syn_set_path(syn_set, :anchor => 'begreber')
      }
      h[syn_set.id] = syn_set.attributes.merge(extra)
    end
    h.to_json.html_safe
  end

end
