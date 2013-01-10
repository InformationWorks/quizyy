module Api
  module V1
    class Api::V1::BaseController < ActionController::Base
     respond_to :json,:xml

     def current_attempt
       Attempt.where(:user_id => current_user.id, :is_current =>true).first()
     end
    end
  end
end