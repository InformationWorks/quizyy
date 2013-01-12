class CartItemsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  
  def create
    
    if params[:quiz_id]
      # Add quiz to cart.
      quiz = Quiz.find(params[:quiz_id])
      @cart.cart_items.create(:quiz_id => quiz.id)
    elsif params[:package_id]
      # Add package to cart.
      package = Package.find(params[:package_id])
      @cart.cart_items.create(:package_id => package.id)
    end
    
    logger.info("controller: #{params[:controller]} action: #{params[:action]}")
    
    # Go back to the controller => action from which cart item was created.
    flash[:notice] = 'Test added to cart successfully.'
    redirect_to :controller => params[:back_controller], :action => params[:back_action]
    
  end
  
end