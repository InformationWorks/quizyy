class Role < ActiveRecord::Base
  attr_accessible :name
  
  has_many :roles_users
  has_many :users, :through => :roles_users
  
end
