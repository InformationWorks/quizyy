class CartItemsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  
  def create
   begin
      if params[:quiz_id]
        # Add quiz to cart.
        quiz = Quiz.find(params[:quiz_id])

        cart_item = @cart.cart_items.where(:quiz_id => quiz.id).first

        if cart_item == nil
          @cart.cart_items.create(:quiz_id => quiz.id)
        else
          # If already exists, save to modify updated_at.
          cart_item.save!
        end

        entity = "Test"
      elsif params[:package_id]
        # Add package to cart.
        package = Package.find(params[:package_id])

        cart_item = @cart.cart_items.where(:package_id => package.id).first

        if cart_item == nil
          CartItem.delete_all(["cart_id = ? AND (package_id IS NOT NULL)", @cart.id])
          @cart.cart_items.create(:package_id => package.id)
        else
          # If already exists, save to modify updated_at.
          cart_item.save!
        end

        entity = "Package"
      end

      # Go back to the controller => action from which cart item was created.
      flash[:notice] = "#{entity} added to cart successfully."
      respond_to do |format|
        format.json { render :json => {:data=>cart_item,:success=>true, :message => "#{entity} added to cart successfully."} }
        format.html { redirect_to :controller => params[:back_controller], :action => params[:back_action]}
      end

    rescue Exception => ex
      respond_to do |format|
        format.json { render :json => {:data=>cart_item,:success=>false, :message => ex.message} }
      end
    end
  end
   
  def destroy
    begin
      cart_item = CartItem.find(params[:id])

      if cart_item.package_id == nil
        entity = "Test"
      elsif cart_item.quiz_id == nil
        entity = "Package"
      end

      cart_item.destroy
      flash[:notice] = "#{entity} removed from cart successfully."
      respond_to do |format|
        format.json { render :json => {:data=>cart_item,:success=>true, :message => "#{entity} removed from cart."} }
        format.html {
          # Go back to the controller => action from which cart item was created.
          redirect_to :controller => params[:back_controller], :action => params[:back_action]
        }
      end

    rescue Exception => ex
      respond_to do |format|
        format.json { render :json => {:data=>cart_item,:success=>false, :message => ex.message} }

      end
    end
    
  end
  
end