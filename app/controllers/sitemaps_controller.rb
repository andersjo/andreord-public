#coding: utf-8
class SitemapsController < ApplicationController
  def show
    @word_senses = DanNet::WordSense.all(
      :limit  => SITEMAPS_PER_FILE,
      :offset => params[:id].to_i*SITEMAPS_PER_FILE,
      :order => 'id')
  end
end
