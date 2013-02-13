class Category < ActiveRecord::Base
  attr_accessible :code, :name, :section_type_id
  has_many :quizzes
  
  validates :code, :name, :slug, :presence => true
  validates :code, :uniqueness => true
  validates :name, :uniqueness => true
  before_validation :generate_slug
  
  belongs_to :section_type
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug = name.parameterize
  end
   
end
