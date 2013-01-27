class QuizType < ActiveRecord::Base
  attr_accessible :name
  
  validates :name,:slug,:presence => true
  validates :name, :uniqueness => true
  before_validation :generate_slug
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug = name.parameterize
  end
  
end
