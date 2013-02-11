class Option < ActiveRecord::Base
  belongs_to :question
  attr_accessible :content, :correct, :sequence_no
  
  def to_param
    sequence_no
  end
end
