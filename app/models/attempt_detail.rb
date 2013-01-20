class AttemptDetail < ActiveRecord::Base
  belongs_to :attempt
  belongs_to :question
  belongs_to :option
  attr_accessible :attempt_id,:question_id,:option_id,:user_input,:marked
end
