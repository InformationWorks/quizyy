class LandingsController < ApplicationController
  layout "landing"
  def index
    if user_signed_in?
      redirect_to :controller => :homes, :action => :index
    end
    
  end
end
