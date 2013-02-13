class Topic < ActiveRecord::Base
  attr_accessible :name, :section_type_id
  has_many :quizzes
  
  validates :name, :slug, :presence => true
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
