class CheckoutController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:z_response]
  before_filter :initialize_cart
  protect_from_forgery :except => [:z_response]

  def show_cart
    
  end
  
  def post_order_to_zaakpay
    
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
    # params.merge!(:orderId => order.id)
    
    # Remove extra params. Zaakpay needs only relavent params.
    params.delete :authenticity_token
    params.delete :utf8
    
    zr = Zaakpay::Request.new(params) 
    @zaakpay_data = zr.all_params   
    render :layout => false    
  end
  
  # POST /z_response
  def z_response
    zr = Zaakpay::Response.new(request.raw_post)  
    @checksum_check = zr.valid?
    @zaakpay_post = zr.all_params
    render :layout => false
  end
  
end