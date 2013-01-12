class CartsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  
  def index
    
  end
  
end