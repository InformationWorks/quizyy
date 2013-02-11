module Admins
  class TransactionsController < ApplicationController
    
    before_filter :authenticate_user!
    load_and_authorize_resource
    
    def index
      @transactions = Transaction.find(:all, :order => "created_at desc")
    end
  end
end