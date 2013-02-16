class TestCenterController < ApplicationController
  
  before_filter :authenticate_user!

  layout "testcenter"
  def index
    if params[:quiz_id]
      #cookies[:current_quiz_id] = params[:quiz_id]
      @quiz_id = "#{params[:quiz_id].to_i}"
      quiz = Quiz.find(@quiz_id)
      time_for_first_section = quiz.timed ? quiz.sections.where(:sequence_no => 1).select(:time).first().time * 60 : 1

      if QuizUser.where('user_id = ? AND quiz_id = ?',current_user.id,@quiz_id).length > 0
        @attempt = Attempt.where("user_id = ? AND quiz_id = ?",current_user.id.to_s,@quiz_id)\
                    .first_or_create(:user_id=> current_user.id,:quiz_id=>@quiz_id,:current_time=>time_for_first_section)
        @attempt.set_attempt_as_current unless(@attempt.is_current)
      else
        redirect_to :action => 'error'
      end
    end
  end
  def error
    flash[:error] = "Please purchase this quiz to start the test. Thank You."
  end
end