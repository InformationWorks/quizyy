class Category < ActiveRecord::Base
  attr_accessible :code, :name
  has_many :quizzes
end
