class ReportsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def show
    @quiz_id = params[:id]
    @attempt = Attempt.find_by_quiz_id_and_user_id(@quiz_id,current_user.id)
    @full_report = @attempt[:report].nil? ? @attempt[:report].each{|k,v| @attempt[:report][k] = eval(v)} : @attempt.calculate_score()[:report].each{|k,v| @attempt[:report][k] = eval(v)}  end
    highest_score_report = @attempt.get_with_highest_score()[:report] || @attempt.get_with_highest_score().calculate_score()[:report]
    @full_report[:highest_attempt] = highest_score_report.each{|k,v| highest_score_report[k] = eval(v)}
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
