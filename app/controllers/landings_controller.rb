class LandingsController < ApplicationController
  
  before_filter :authenticate_user!
  
  layout "landing"
  def index
    if user_signed_in?
      redirect_to :controller => :homes, :action => :index
    end
    
  end
end
