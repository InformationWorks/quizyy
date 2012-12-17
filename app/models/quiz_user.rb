class QuizUser < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :user
  # attr_accessible :title, :body
end
