class ReportsController < ApplicationController
  before_filter :authenticate_user!
  def index

  end

  def show
    @quiz_id = params[:id]
    #TODO create view for category test report
    if Quiz.find(@quiz_id).quiz_type.name == "FullQuiz"
      @attempt = Attempt.find_by_quiz_id_and_user_id(@quiz_id,current_user.id)
      @full_report = @attempt[:report].nil? ? @attempt.calculate_score()[:report].each{|k,v| @attempt[:report][k] = eval(v)} : @attempt[:report].each{|k,v| @attempt[:report][k] = eval(v)}
      section_types = SectionType.all()
      categories = Category.all()
      main_section_report = Hash[section_types.map{|t| [t.name, Hash['correct' => 0,'total' =>0 ]]}]
      categories_report = Hash[categories.map{|c| [c.code,Hash['correct' => 0,'total' =>0, 'name'=>c.name]] }]
      @full_report['section_report'].each do |key,value|
        main_section_report[value['section_type']]['correct'] += value['correct']
        main_section_report[value['section_type']]['total'] += value['total']
      end
      @full_report['type_report'].each do |name,value|
        categories_report[value['category_code']]['correct'] += value['correct']
        categories_report[value['category_code']]['total'] += value['total']
      end
      highest_score_report = @attempt.get_with_highest_score()[:report] || @attempt.get_with_highest_score().calculate_score()[:report]
      @full_report['main_section_report'] = main_section_report
      @full_report['category_report'] = categories_report
      @full_report['highest_attempt'] = highest_score_report.each{|k,v| highest_score_report[k] = eval(v)}
      respond_to do |format|
        format.html # show.html.erb
      end
    end
  end
end