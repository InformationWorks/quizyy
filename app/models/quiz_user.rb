class QuizUser < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :user
  # attr_accessible :title, :body
  
  # Return the status of the quiz for a user.
  # :new => Quiz bought but not started yet.
  # :paused => Quiz started but not completed.
  # :completed => Quiz completed.
  def status
    attempts = Attempt.where(:quiz_id => self.quiz_id,:user_id => self.user_id)
    
    if attempts.count == 0
      return :new
    else
      # iterate through attempts and return :compelted if
      # any attempt with completed => true is encountered.
      # else return :paused
      attempts.each do |attempt|
        if attempt.completed
          return :completed
        end
      end
      return :paused
    end
  end
  
end
