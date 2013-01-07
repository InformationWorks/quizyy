class SectionType < ActiveRecord::Base
  attr_accessible :instruction, :name
  
  validates :name,:instruction, :presence => true
  validates :name, :uniqueness => true
end
