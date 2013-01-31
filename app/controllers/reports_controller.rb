class ReportsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @attempts = Attempt.where('user_id = ? and completed = true',current_user.id).includes(:quiz).all()
    @attempts.each {|attempt| attempt[:report].each{|k,v| attempt[:report][k] = eval(v)}}
  end

  def show
    
    @quiz = current_user.quizzes.find_by_slug(params[:id])

    if @quiz == nil
      @quiz = current_user.quizzes.find(params[:id])
    end
    
    @quiz_id = @quiz.id
    #TODO create view for category test report
    if Quiz.find(@quiz_id).quiz_type.name == "FullQuiz"
      @attempt = Attempt.find_by_quiz_id_and_user_id(@quiz_id,current_user.id)
      @full_report = @attempt[:report].nil? ? @attempt.calculate_score()[:report].each{|k,v| @attempt[:report][k] = eval(v)} : @attempt[:report].each{|k,v| @attempt[:report][k] = eval(v)}
      categories = Category.all()
      categories_report = Hash[categories.map{|c| [c.code,Hash['correct' => 0,'total' =>0, 'name'=>c.name]] }]
      @full_report['type_report'].each do |name,value|
        categories_report[value['category_code']]['correct'] += value['correct']
        categories_report[value['category_code']]['total'] += value['total']
      end
      highest_score_report = @attempt.get_with_highest_score()[:report] || @attempt.get_with_highest_score().calculate_score()[:report]
      @full_report['category_report'] = categories_report
      @full_report['highest_attempt'] = highest_score_report.each{|k,v| highest_score_report[k] = eval(v)}
      @full_report['total_score'] = @attempt.score.to_i()
      respond_to do |format|
        format.html # show.html.erb
      end
    end
  end
end
