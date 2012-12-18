class QuizUser < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :user
  # attr_accessible :title, :body
  
  # Return the status of the quiz for a user.
  # :new => Quiz bought but not started yet.
  # :paused => Quiz started but not completed.
  # :completed => Quiz completed.
  def status
    # TODO: Insert code here for detecting the status of a quiz.
    return :new
  end
  
end
