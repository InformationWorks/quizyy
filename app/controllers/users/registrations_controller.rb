# Custom implementation of devise controller to restrict registration.
class Users::RegistrationsController < Devise::RegistrationsController
  
  before_filter :check_permissions, :only => [:new, :create, :cancel]
  skip_before_filter :require_no_authentication
 
  def check_permissions
    raise CanCan::AccessDenied unless can? :manage, User
    #authorize! :create, resource # devise uses resource to refer to the model that can be authenticated.
    logger.info("In check_permissions") 
  end
end