class ReportsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def show
    @quiz_id = params[:id]
    @attempt = Attempt.find_by_quiz_id_and_user_id(@quiz_id,current_user.id)
    if @attempt[:report].nil?
      @full_report = @attempt.calculate_score()[:report].each{|k,v| @attempt[:report][k] = eval(v)}
    else
      @full_report = @attempt[:report].each{|k,v| @attempt[:report][k] = eval(v)}
    end
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
