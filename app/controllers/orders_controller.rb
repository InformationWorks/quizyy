class OrdersController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @orders = current_user.orders.order("updated_at desc")
  end

  def show
  end
end
