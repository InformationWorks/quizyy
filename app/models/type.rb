class Type < ActiveRecord::Base
  belongs_to :category
  attr_accessible :code, :name, :category_id
  
  validates :code,:name,:category_id,:presence => true
  validates :code, :uniqueness => true
  validates :name, :uniqueness => true
end
