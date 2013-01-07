class Topic < ActiveRecord::Base
  attr_accessible :name
  has_many :quizzes
  
  validates :name, :presence => true
  validates :name, :uniqueness => true
end
