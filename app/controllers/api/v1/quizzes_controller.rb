module Api
  module V1
    class QuizzesController < Api::V1::BaseController
      def show
        @quiz = Quiz.find(params[:id])
        @current_attempt = Attempt.where(:user_id => current_user.id, :is_current =>true).first()
        @current_question = Question.find(@current_attempt.current_question_id) if @current_attempt.current_question_id
        @current_section = @current_question.section.id if @current_question
      end
    end
  end
end