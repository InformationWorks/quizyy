class Section < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :section_type
  attr_accessible :name, :sequence_no,:section_type_id,:display_text
  has_many :questions,:dependent => :destroy
  scope :with_all_association_data, includes({:questions=>[:options,:type]},:section_type).order('sections.sequence_no')
end
