class Attempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :quiz
  attr_accessible :user_id, :quiz_id, :completed, :current_question_id,:current_section_id, :is_current

  def set_attempt_as_current
    Attempt.where("user_id = ?",self.user.id).each do |attempt|
      attempt.is_current = false
      attempt.save
    end
    self.is_current = true
    self.save
  end
end
