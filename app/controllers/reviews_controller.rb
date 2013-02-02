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
          if user_answers!="" and correct_answers == user_answers
            question[:correct] = true
          else
            question[:correct] = false
          end
        end
      end
      respond_to do |format|
        format.html # show.html.erb
      end
    end
  end
end
