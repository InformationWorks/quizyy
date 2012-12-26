class Section < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :section_type
  attr_accessible :name, :sequence_no,:section_type_id,:display_text
  has_many :questions,:dependent => :destroy
end
