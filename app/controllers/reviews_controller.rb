class ReviewsController < ApplicationController
  def show
    @quiz = current_user.quizzes.find_by_slug(params[:id])

    if @quiz == nil
      @quiz = current_user.quizzes.find(params[:id])
    end

    @quiz_id = @quiz.id
    questions_have_no_options = %w(V-SIP Q-NE-1 Q-NE-2 Q-DI-NE-1 Q-DI-NE-2)
    #TODO create view for category test report
    if Quiz.find(@quiz_id).quiz_type.name == "FullQuiz"
      numericEqRegEx = /NE-1|NE-2/i
      textCompRegEx = /TC-1|TC-2|TC-3/i
      sipRegEx = /SIP/i
      @sections = Section.with_all_association_data.find_all_by_quiz_id(@quiz_id)
      @attempt = Attempt.find_by_quiz_id_and_user_id(@quiz_id,current_user.id)
      attempt_details = AttemptDetail.find_all_by_attempt_id(@attempt.id)
      @sections.each do |section|
        section.questions.each do |question|
          if questions_have_no_options.include?(question.type.code)
            correct_answers = question.options.collect{|o| o.content}.first().to_s()
            user_answers = attempt_details.find_all{ |a| a.question_id==question.id}.collect{|a| a.user_input}.first().to_s()
          else
            correct_answers = question.options.find_all{ |o| o.correct }.collect{|o| o.id }.sort().join(',')
            user_answers = attempt_details.find_all{ |a| a.question_id==question.id }.collect{|a| a.option_id}.sort.join(',')
          end
          question.options.each do |option|
            if !questions_have_no_options.include?(question.type.code)
              if attempt_details.find_all{ |a| a.option_id==option.id }.length > 0
                option[:selected_by_user] = true
              else
                option[:selected_by_user] = false
              end
            end
          end

          question[:user_answers] = user_answers
          if user_answers!="" and correct_answers == user_answers
            question[:correct] = true
          else
            question[:correct] = false
          end
          if question.type.code =~ numericEqRegEx
            question[:option_type] = :ne
          elsif question.type.code =~ textCompRegEx
            question[:option_type] = :tc
          elsif question.type.code =~ sipRegEx
            question[:option_type] = :sip
          else
            question[:option_type] = :mcq
          end
        end
      end
      respond_to do |format|
        format.html # show.html.erb
      end
    end
  end
end
