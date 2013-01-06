class AdminsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :allow_only_admins!
  
  def home
  end
  
  private
  
  def allow_only_admins!
    authorize! :administer, :app
  end
  
end
