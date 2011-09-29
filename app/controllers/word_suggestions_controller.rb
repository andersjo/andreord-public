#coding: utf-8
class WordSuggestionsController < ApplicationController

  def index
    lemmas = DanNet::Word.suggest_lemmas_by_part(params[:query])
    render :text => lemmas*"\n"
  end

end
