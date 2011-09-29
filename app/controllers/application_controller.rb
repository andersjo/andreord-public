class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def bind_query
    @query = params[:query] and params[:query].strip.downcase
  end

end
