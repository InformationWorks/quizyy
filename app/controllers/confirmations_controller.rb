class ConfirmationsController < Devise::ConfirmationsController
  def show
    #@confirmation_token = params[:confirmation_token]
    self.resource = resource_class.find_by_confirmation_token(params[:confirmation_token])
    super if resource.confirmed? 
  end

  def confirm
    logger.info("Resource name = " + resource_name.to_s)
    logger.info("Params = " + params.to_s)
    logger.info("Confirmation Token = " + params[resource_name][:confirmation_token].to_s)
    self.resource = resource_class.find_by_confirmation_token(params[resource_name][:confirmation_token])
    if resource.update_attributes(params[resource_name].except(:confirmation_token)) && resource.password_match?
      logger.info("True")
      self.resource = resource_class.confirm_by_token(params[resource_name][:confirmation_token])
      set_flash_message :notice, :confirmed
      # Call overridden function.
      sign_in_and_redirect(resource_name, resource)
    else
      render :action => "show"
    end
  end
  
  private
  
  # Override devise method.
  def sign_in_and_redirect(resource_or_scope,resource)
    if resource_or_scope == :user && resource != nil
      sign_in(resource_or_scope, resource)
      redirect_to homes_index_path, notice: "Account successfully confirmed. All the best for your preparation."
    else
      super
    end
  end
  
end