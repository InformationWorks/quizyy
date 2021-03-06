module Api
  module V1
    class QuizzesController < Api::V1::BaseController
      def show
        @quiz = Quiz.find(params[:id])
        #TODO should we pass user id instead of using the current_user method
        #using the method renders the api useless for other clients like android,ios etc
        @current_attempt = Attempt.where(:user_id => current_user.id, :is_current =>true).first()
        @current_question = Question.find(@current_attempt.current_question_id) if @current_attempt.current_question_id
        @current_section =  @current_question ?  @current_question.section : Section.find(@current_attempt.current_section_id) if @current_attempt.current_section_id
      end
    end
  end
end