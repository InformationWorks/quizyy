class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :cart_items, :dependent => :destroy
  has_many :quizzes, :through => :cart_items
  has_many :packages, :through => :cart_items
  
  attr_accessible :user_id
end
