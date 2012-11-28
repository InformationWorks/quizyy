class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  
  # Devise override
  #def after_sign_in_path_for(resource)
  #  homes_index_path
  #end
  
  # Devise override
  # def after_sign_out_path_for(resource_or_scope)
  #   request.referrer
  # end
  
  # session[:user_return_to] used by stored_location_for in devise.
  # Fixed redirect back to current page after sign in.
  # If a user is not signed in and the user access a page that 
  # needs authentication, devise redirects the user to sign in page
  # once the user signs in we need to send them back to the page
  # that the user tried to access. 
  def store_location
      session[:user_return_to] = request.url unless params[:controller] == "devise/sessions"
  # If devise model is not User, then replace :user_return_to with :{your devise model}_return_to
  end
  
  def after_sign_in_path_for(resource)
      stored_location_for(resource) || homes_index_path
  end
  
end
