class AttemptDetail < ActiveRecord::Base
  belongs_to :attempt
  belongs_to :question
  belongs_to :option
  attr_accessible :time_spent
end
