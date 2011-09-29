#coding: utf-8
class DdoMappingsController < ApplicationController
  def show
    @ddo_mapping = DanNet::DdoMapping.find_by_ddo_id(params[:id])
    if @ddo_mapping
      redirect_to ord_path(@ddo_mapping.word_sense), :status => :moved_permanently
    else
      render :text => "Ordet findes ikke i DanNet", :status => :not_found
    end
  end
end
