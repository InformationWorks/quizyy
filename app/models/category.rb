class Category < ActiveRecord::Base
  attr_accessible :code, :name
  has_many :quizzes
  
  validates :code,:name, :presence => true
  validates :code, :uniqueness => true
  validates :name, :uniqueness => true
end
