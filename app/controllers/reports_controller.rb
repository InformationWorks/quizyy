class ReportsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def show
    @quiz_id = params[:id]
    @attempt = Attempt.find_by_quiz_id_and_user_id(@quiz_id,current_user.id)
    @sections = Section.with_all_association_data.find_all_by_quiz_id(@quiz_id)
    @type = Type.all()
    section_report ={}
    type_report = Hash[ @type.map{|t| [t.name,0]} ]
    questions_have_no_options = %w('V-SIP','Q-NE-1','Q-NE-2','Q-DI-NE-1','Q-DI-NE-2')
    unless @attempt.nil?
      @attempt_details = AttemptDetail.find_all_by_attempt_id(@attempt.id)
      total_correct = 0
      total_question = 0
      @sections.each do |section|
        correct = 0
        section.questions.each do |question|
          if questions_have_no_options.include?(question.type.code)
            correct_answers = question.options.collect{|o| o.content}.first().to_s()
            user_answers = @attempt_details.find_all{ |a| a.question_id==question.id}.collect{|a| a.user_input}.first().to_s()
          else
            correct_answers = question.options.find_all{ |o| o.correct }.collect{|o| o.id }.sort().join(',')
            user_answers = @attempt_details.find_all{ |a| a.question_id==question.id }.collect{|a| a.option_id}.sort.join(',')
          end
          if user_answers!="" and correct_answers == user_answers
            correct +=1
            total_correct+=1
            type_report[question.type.name] =+ 1
          end
          total_question += 1
        end
        section_report[section.id] = {:section_name => section.name,:section_type => section.section_type.name,:correct=>correct,:total => section.questions.length}
      end
      @full_report = Hash[:section_report => section_report,:type_report => type_report, :total_score => {:correct=>total_correct,:total=>total_question}]
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
