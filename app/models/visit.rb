class Visit < ActiveRecord::Base
  belongs_to :attempt
  belongs_to :question
  attr_accessible :attempt_id, :question_id, :time_spent
end
