class Admins::ReportsController < ApplicationController
  def index
    @quizzes = Quiz.select('id,name')
    unless params[:quiz].nil?
      msg = nil
      if params[:attempt_date].blank? and params[:quiz][:id].blank?
        msg = 'Please select a Quiz and a Date'
      elsif params[:quiz][:id].blank?
        msg = 'Please select a Quiz'
      elsif params[:attempt_date].blank?
        msg = 'Please select a Date'
      else
        @date_of_attempt = Date.parse(params[:attempt_date],'%d/%m/%Y')
        quiz_id = params[:quiz][:id]
        @quiz = Quiz.find(quiz_id)
        @attempts = Attempt.search_by_date_and_quiz_id(@date_of_attempt,quiz_id)
        @attempts.each do |attempt|
          if attempt[:report]
            attempt[:report].each{|k,v| attempt[:report][k] = eval(v)}
          end
        end
      end
      flash[:notice] = msg
    end
  end
end
