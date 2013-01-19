class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.find(:all, :order => "created_at desc")
  end
end
