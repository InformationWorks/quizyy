class TestCenterController < ApplicationController
  layout "testcenter"
  def index
    if request.post?
      cookies[:current_quiz_id] = params[:quiz_id]
    else
      #we might have think what to do here
    end
  end
end
