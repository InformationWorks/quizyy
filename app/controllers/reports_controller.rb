class ReportsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def show
    @quiz_id = params[:id]
    @attempt = Attempt.find_by_quiz_id_and_user_id(@quiz_id,current_user.id)
    @full_report = @attempt[:report].nil? ? @attempt[:report].each{|k,v| @attempt[:report][k] = eval(v)} : @attempt.calculate_score()[:report].each{|k,v| @attempt[:report][k] = eval(v)}
    section_types = SectionType.all()
    main_section_report = Hash[section_types.map{|t| [t.name => {'correct' => 0,'total' =>0 }]}]
    #@full_report['section_report'].each do |key,value|
    #  main_section_report[value['section_type_name']]['correct'] =+ value['correct']
    #end
    @full_report['main_section_report'] = main_section_report
    highest_score_report = @attempt.get_with_highest_score()[:report] || @attempt.get_with_highest_score().calculate_score()[:report]
    @full_report[:highest_attempt] = highest_score_report.each{|k,v| highest_score_report[k] = eval(v)}
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
