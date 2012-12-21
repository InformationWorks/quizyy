class PackageQuiz < ActiveRecord::Base
  belongs_to :package
  belongs_to :quiz
  # attr_accessible :title, :body
end
