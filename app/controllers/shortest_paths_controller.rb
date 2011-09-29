#coding: utf-8
class ShortestPathsController < ApplicationController
  before_filter :bind_src_and_dst, :only => :show
  
  def show
    @path = @src.syn_set.shortest_path_to(@dst.syn_set)
    if @path
      @relations = DanNet::Relation.relations_for_path(@path)
    end
  end

  def disambiguate
    @src_senses = find_senses(params[:src])
    @dst_senses = find_senses(params[:dst])
    if [@src_senses, @dst_senses].all? {|s| s.size == 1 }
      redirect_to :overwrite_params => {:action => :show}
    end
  end
  
  private
  def bind_src_and_dst
    @src = DanNet::WordSense.find_by_heading(params[:src])
    @dst = DanNet::WordSense.find_by_heading(params[:dst])
    unless @src and @dst
      redirect_to url_for :overwrite_params => {:action => :disambiguate}
    end
  end

  def find_senses(sense_str)
    sense = DanNet::WordSense.find_by_heading(sense_str)
    if sense.nil?
      DanNet::WordSense.with_lemma(sense_str)
    else
      [sense]
    end

  end

end
