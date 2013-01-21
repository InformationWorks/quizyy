class ProgressReportController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def show
  	@quiz_id = params[:id]
  	@attempt = Attempt.where(:quiz_id=>@quiz_id,:user_id=>current_user.id)
  	@sections = Section.joins(:section_type,:questions=>:options)
  	@report ={}

  	@questions_have_no_options = ['V-SIP','Q-NE-1','Q-NE-2','Q-DI-NE-1','Q-DI-NE-2']
  	if @attempt.length > 0
  		@current_attempt = @attempt.first()
  		@attempt_details = AttemptDetail.where(:attempt_id=>@current_attempt.id)
  		@sections.each do |section|
  			@correct = 0
  			@question_with_type = section.questions.joins(:type)
  			@question_with_type.each do |question|
  				@correct_answers = question.options.where(:correct=>true).select(:content).join(',')
  				if @questions_have_no_options.include?(question.type.code)
  					@user_answers = @attempt_details.where(:question_id=>question.id).select(:user_input)
  				else
  					@user_answers = @attempt_details.where(:question_id=>question.id).select(:option_id).to_a().join(',')
  				end
  				if @correct_answers == @user_answers
  					@correct +=1
  				end
  			end
  			@report[section.id] = {:section_name => section.name,:section_type => section.section_type.name,:correct=>@correct,:total => section.questions.length}
  		end
  	end

  	respond_to do |format|
      format.html # show.html.erb
    end
  end	
end
