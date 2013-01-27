class SectionType < ActiveRecord::Base
  attr_accessible :instruction, :name
  
  validates :name,:instruction,:slug,:presence => true
  validates :name, :uniqueness => true
  before_validation :generate_slug
  
  has_many :categories
  has_many :topics
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug = name.parameterize
  end
  
end
