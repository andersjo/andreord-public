#coding: utf-8
class WordSenseGraphsController < ApplicationController
  def show
    @graph = DanNet::WordSenseGraph.new(DanNet::WordSense.find(params[:id]))
    respond_to do |wants|
      wants.xml
    end
  end
end
