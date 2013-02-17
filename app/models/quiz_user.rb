##
# This class represents a QuizUser. This class keeps track of
# the quizzes owned by the users.
class QuizUser < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  # ----------------------------------------------------------
  # Validations
  
  # ----------------------------------------------------------
  # Before-After Callbacks
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :quiz
  belongs_to :user
  
  # ----------------------------------------------------------
  # has_many
  
  # ----------------------------------------------------------
  # has_many :through
  
  ############################################################
  # Scopes
  ############################################################
  
  # ----------------------------------------------------------
  # Direct scopes
  
  # ----------------------------------------------------------
  # Lambda scopes
  
  ###########################################################
  # Functions
  ############################################################
  
  # ----------------------------------------------------------
  # Overrides
  
  # ----------------------------------------------------------
  # Instance methods
 
  # Get the status of the quiz for a user.
  # 
  # :new => Quiz bought but not started yet.
  # :paused => Quiz started but not completed.
  # :completed => Quiz completed.
  # 
  # # ==== Returns
  # * <tt>status</tt> - :new, :paused or :completed.
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
 
  # ----------------------------------------------------------
  # Class methods
  
end
