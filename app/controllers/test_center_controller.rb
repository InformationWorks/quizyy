class TestCenterController < ApplicationController
  
  before_filter :authenticate_user!

  layout "testcenter"
  def index
    if params[:quiz_id]
      #cookies[:current_quiz_id] = params[:quiz_id]
      @attempt = Attempt.where(["user_id = ? AND quiz_id = ?",current_user.id.to_s,"#{params[:quiz_id].to_i}"]).first_or_create(:user_id=> current_user.id,:quiz_id=>"#{params[:quiz_id].to_i}")
      @attempt.set_attempt_as_current unless(@attempt.is_current)
    end
    end
end