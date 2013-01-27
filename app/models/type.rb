class Type < ActiveRecord::Base
  belongs_to :category
  attr_accessible :code, :name, :category_id
  
  validates :code,:name,:category_id,:slug,:presence => true
  validates :code, :uniqueness => true
  validates :name, :uniqueness => true
  before_validation :generate_slug
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug = code.parameterize
  end
  
end
