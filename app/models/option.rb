class Option < ActiveRecord::Base
  belongs_to :question
  attr_accessible :content, :correct, :sequence_no
end
