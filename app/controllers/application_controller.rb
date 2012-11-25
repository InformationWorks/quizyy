class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  
  # Devise override
  def after_sign_in_path_for(resource)
    homes_index_path
  end
  
  # Devise override
  # def after_sign_out_path_for(resource_or_scope)
  #   request.referrer
  # end
  
end
