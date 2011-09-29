#coding: utf-8
class DisambiguationsController < ApplicationController
  before_filter :bind_query
  before_filter :bind_senses

  def show
  
  end

  def bind_senses
    @senses = DanNet::Word.find_all_by_lemma(@query).map(&:word_senses).flatten
    @senses = @senses.sort_by {|ws| ws.heading }
  end

end
