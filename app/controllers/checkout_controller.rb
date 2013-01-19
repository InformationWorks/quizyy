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
    
    if params[:orderId] == nil
      # Generate Order for the current cart
      # and add order.id to params
      order = create_order(@cart.id)
      params.merge!(:orderId => order.id)
    else
      # Retrive existing Order
      order = Order.find(params[:orderId])
    end
    
    if params[:amount].to_i == 0
      # Set order as processed
      mark_order_as_processed(order)
      
      # Process the order and add the quiz/package to the user's account.
      process_order(order)
      
      # Log the activity in transactions table.
      Transaction.create!( :ipaddress => request.remote_ip.to_s, 
                           :action => "Free tests added to your account.",
                           :responseCode => 100,
                           :responseDescription => "Free tests added to your account.",
                           :user_id => current_user.id,
                           :order_id => order.id)
      
      # Redirect to order's page.
      redirect_to order_path(order), notice: "Order processed successfully."
    else
      # Handle payment for paid test.
      zr = Zaakpay::Request.new(params) 
      @zaakpay_data = zr.all_params   
      render :layout => false
    end
    
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
      
      Transaction.create!( :ipaddress => request.remote_ip.to_s, 
                           :action => "CHECKSUM_ERROR",
                           :responseCode => -1,
                           :responseDescription => "Checksum mismatch error.",
                           :user_id => current_user.id,
                           :order_id => order.id)
    else
      # Save order values.
      order = save_order(@zaakpay_post)
      
      Transaction.create!( :ipaddress => request.remote_ip.to_s, 
                           :action => "ZAAKPAY_RESPONSE",
                           :responseCode => order.responseCode,
                           :responseDescription => order.responseDescription,
                           :user_id => current_user.id,
                           :order_id => order.id)
      
      # If responseCode == 100, add the quizzes/packages to user's account.
      if order.responseCode == 100
        process_order(order)
        
        Transaction.create!( :ipaddress => request.remote_ip.to_s, 
                           :action => "PROCESS_ORDER",
                           :responseCode => order.responseCode,
                           :responseDescription => "Order processed successfully",
                           :user_id => current_user.id,
                           :order_id => order.id)
        
        redirect_to order_path(order), notice: "Order processed successfully."
      else
        redirect_to order_path(order), notice: "Order processing failed."
      end
    end
  end
  
  private
  
  def mark_order_as_processed(order)
    order.responseCode = 100
    order.responseDescription = "Free tests added to your account."
    order.save!
  end
  
  def create_order(cart_id)
    order = Order.new
    order.cart_id = @cart.id
    order.save!
    order
  end
  
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