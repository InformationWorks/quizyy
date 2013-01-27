class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location
  before_filter :instantiate_controller_and_action_names
  before_filter :initialize_cart

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    
    # For controllers under "Admin" section redirect to specific index page.
    if @current_controller == "topics"
      flash[:error] = "You are not authorized to do this  <span class='emo-tongue' data-original-title='.emo-tongue'></span>".html_safe 
      redirect_to topics_url
    elsif @current_controller == "categories"
      flash[:error] = "You are not authorized to do this  <span class='emo-tongue' data-original-title='.emo-tongue'></span>".html_safe 
      redirect_to categories_url
    elsif @current_controller == "types"
      flash[:error] = "You are not authorized to do this  <span class='emo-tongue' data-original-title='.emo-tongue'></span>".html_safe 
      redirect_to types_url
    elsif @current_controller == "packages"
      flash[:error] = "You are not authorized to do this  <span class='emo-tongue' data-original-title='.emo-tongue'></span>".html_safe 
      redirect_to packages_url
    elsif @current_controller == "quiz_types"
      flash[:error] = "You are not authorized to do this  <span class='emo-tongue' data-original-title='.emo-tongue'></span>".html_safe 
      redirect_to quiz_types_url
    elsif @current_controller == "section_types"
      flash[:error] = "You are not authorized to do this  <span class='emo-tongue' data-original-title='.emo-tongue'></span>".html_safe 
      redirect_to section_types_url
    else
      redirect_to homes_index_url
    end
  
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
  
  def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
  end
  
  private

  # Pick up the existing cart if a corresponding entry is not created in order table.
  # Once a entry is inserted in the order table, cart entry is to be considered as 
  # processed and a new cart should be used for future processing. User will be 
  # shown a orders page to check status of the created orders.
  def initialize_cart
    if @cart == nil
      @cart = Cart.joins("left join orders o on carts.id = o.cart_id").where("o.id is null AND carts.user_id = ?", current_user.id).first
      if @cart == nil
        @cart = Cart.create(:user_id => current_user.id)
      end
    end
  end
  
end
