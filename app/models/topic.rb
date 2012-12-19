class Topic < ActiveRecord::Base
  attr_accessible :name
  has_many :quizzes
end
