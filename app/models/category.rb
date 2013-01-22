class Category < ActiveRecord::Base
  attr_accessible :code, :name, :section_type_id
  has_many :quizzes
  
  validates :code,:name, :presence => true
  validates :code, :uniqueness => true
  validates :name, :uniqueness => true
  
  belongs_to :section_type
end
