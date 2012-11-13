class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :roles_users
  has_many :roles, :through => :roles_users
  
  def role?(role)
    # Original:- return !!self.roles.find_by_name(role.to_s.camelize)
    return self.roles.find_by_name(role.to_s.camelize) == nil 
  end
  
end
