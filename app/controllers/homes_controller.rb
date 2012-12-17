class HomesController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:index]
  
  def index
    split_user_full_name = current_user.full_name.split(' ',2)
    @first_name = split_user_full_name[0]
    @last_name = split_user_full_name[1]
  end
end
