#coding: utf-8
class WrongSpellingsController < ApplicationController
  before_filter :bind_query

  def show
    render :status => :not_found, :layout => 'application'
  end
end
