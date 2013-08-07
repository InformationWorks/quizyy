class Admins::ReportsController < ApplicationController
  def index
    @quizzes = Quiz.select("id,name")
    unless params.nil?
      if params[:attempt].nil? and params[:quiz_id].nil?
        render :action => 'index', :notice => "Please select a Quiz and a Date"
      elsif params[:quiz_id].nil?
        render :action => 'index', :notice => "Please select a Quiz"
      elsif params[:attempt].nil?
        render :action => 'index', :notice => "Please select a Date"
      else
        created_on = Date.civil(params[:attempt][:"created_on(1i)"].to_i,params[:attempt][:"created_on(2i)"].to_i,params[:attempt][:"created_on(3i)"].to_i)
        quiz_id = params[:quiz_id]
        @attempts = Attempt.search_by_date_and_quiz_id(created_on,quiz_id)
      end
    end
  end
end
