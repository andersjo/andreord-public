#coding: utf-8
class RelationsGraphsController < ApplicationController
  def shallow_syn_set
    syn_set = DanNet::SynSet.find(params[:id])
    g = Graphs::SynSetGraph.new(syn_set)
    send_data(g.to_png,
      :filename => "#{syn_set.id}.png",
      :disposition => 'inline',
      :type => 'image/png')
  end

end
