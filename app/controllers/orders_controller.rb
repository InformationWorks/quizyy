class OrdersController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @orders = current_user.orders.order("updated_at desc")
  end

  def show
    @order = Order.find(params[:id])
  end
  
  def transactions
    @transactions = Transaction.where(:order_id => params[:id])
    @order = Order.find(params[:id])
  end
end
