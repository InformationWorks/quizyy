class ConfirmationsController < Devise::ConfirmationsController
  
  include OrdersHelper
  
  def show
    #@confirmation_token = params[:confirmation_token]
    self.resource = resource_class.find_by_confirmation_token(params[:confirmation_token])
    super if resource.confirmed? 
  end

  def confirm
    
    self.resource = resource_class.find_by_confirmation_token(params[resource_name][:confirmation_token])
    if resource.update_attributes(params[resource_name].except(:confirmation_token)) && resource.password_match?
      
      # Confirm user.
      self.resource = resource_class.confirm_by_token(params[resource_name][:confirmation_token])
      set_flash_message :notice, :confirmed 
      
      # Check for offers.
      offer_messages = OrdersHelper.after_confirmation_offers(self.resource)
           
      flash[:offer_messages] = offer_messages.map{|s| "#{s}"}.join('<br /><br />')
      
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