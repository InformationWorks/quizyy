class CartItemsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  
  def create
    
    if params[:quiz_id]
      # Add quiz to cart.
      quiz = Quiz.find(params[:quiz_id])
      @cart.cart_items.create(:quiz_id => quiz.id)
      entity = "Test"
    elsif params[:package_id]
      # Add package to cart.
      package = Package.find(params[:package_id])
      @cart.cart_items.create(:package_id => package.id)
      entity = "Package"
    end
    
    # Go back to the controller => action from which cart item was created.
    flash[:notice] = "#{entity} added to cart successfully."
    redirect_to :controller => params[:back_controller], :action => params[:back_action]
    
  end
  
  def destroy
    
    cart_item = CartItem.find(params[:id])
    
    if cart_item.package_id == nil
      entity = "Test"
    elsif cart_item.quiz_id == nil
      entity = "Package"
    end
    
    cart_item.destroy
    
    # Go back to the controller => action from which cart item was created.
    flash[:notice] = "#{entity} removed from cart successfully."
    redirect_to :controller => params[:back_controller], :action => params[:back_action]
    
  end
  
end