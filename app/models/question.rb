class Question < ActiveRecord::Base
  belongs_to :type
  belongs_to :topic
  belongs_to :section
  attr_accessible :di_location, :header, :instruction, :option_set_count, :passage, :quantity_a, :quantity_b, :que_image, :que_text, :sequence_no, :sol_image, :sol_text,:type_id,:topic_id
  has_many :options
end
