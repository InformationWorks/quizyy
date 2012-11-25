class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :role_users
  has_many :roles, :through => :role_users
  
  def role?(role)
    
    if ( self.roles.find_by_name(role.to_s.camelize) == nil )
      return false
    else
      return true
    end
    
  end
  
end
