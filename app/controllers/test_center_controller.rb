class TestCenterController < ApplicationController
  layout "testcenter"
  def index
      if params[:quiz_id]
        cookies[:current_quiz_id] = params[:quiz_id]
      end
  end
end
