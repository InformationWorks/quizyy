class CheckoutController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  protect_from_forgery :except => [:z_response]

  def show_cart
    
  end
  
  def buy_test
    @quiz = Quiz.find(params[:id])
  end
  
  def buy_package
    
  end
  
  # POST /post_to_zaakpay
  def post_to_zaakpay
    
    # Generate Order for the current cart.
    order = Order.new
    order.cart_id = @cart.id
    order.save!
    
    # Add orderId to params.
    params.merge!(:orderId => order.id)
    
    zr = Zaakpay::Request.new(params) 
    @zaakpay_data = zr.all_params   
    render :layout => false    
  end
  
  # POST /post_existing_order_to_zaakpay
  # Order id passed in params.
  def post_existing_order_to_zaakpay
    zr = Zaakpay::Request.new(params) 
    @zaakpay_data = zr.all_params   
    render :layout => false
  end
  
  # POST /z_response
  def z_response
    zr = Zaakpay::Response.new(request.raw_post)  
    @checksum_check = zr.valid?
    @zaakpay_post = zr.all_params
    
    # Log Error if checksum does not match
    # Process order for user's account only if the checksum matched.
    if !@checksum_check
      logger.info("CHECKSUM MISMATCH FROM IP-ADDRESS " + request.remote_ip.to_s)
    else
      # Save order values.
      order = save_order(@zaakpay_post)
      
      # If responseCode == 100, add the quizzes/packages to user's account.
      if order.responseCode == 100
        process_order(order)
        redirect_to order_path(order), notice: "Order processed successfully."
      else
        redirect_to order_path(order), notice: "Order processing failed."
      end
    end
  end
  
  private
  
  def save_order(params)
    order = Order.find(params["orderId"].to_i)
    order.responseCode = params["responseCode"].to_i
    order.responseDescription = params["responseDescription"].to_s
    order.save!
    order
  end
  
  def process_order(order)
    cart = Cart.find(order.cart_id)
        
    # Add each cartitem to user's account.
    cart.cart_items.each do | cart_item |
      
      if cart_item.quiz_id != nil
      # Add Quiz
        quiz_user = QuizUser.new
        quiz_user.quiz_id = cart_item.quiz_id
        quiz_user.user_id = current_user.id
        quiz_user.save!
        
      elsif cart_item.package_id != nil
      # Add Package
        package_quizzes_ids = Package.find(cart_item.package_id).quizzes.pluck(:quiz_id)
        package_quizzes_ids.each do |quiz_id|
          quiz_user = QuizUser.new
          quiz_user.quiz_id = quiz_id
          quiz_user.user_id = current_user.id
          quiz_user.save!
        end  
       end        
    end
  end
  
end