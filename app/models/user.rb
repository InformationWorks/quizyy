class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # TODO: :confirmable to be added
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name
  # attr_accessible :title, :body
  
  validates :full_name,  :presence => true
  
  has_many :role_users
  has_many :roles, :through => :role_users
  
  has_many :quiz_users
  has_many :quizzes, :through => :quiz_users
  
  def role?(role)
    
    if ( self.roles.find_by_name(role.to_s.camelize) == nil )
      return false
    else
      return true
    end
    
  end
  
  # Return an array of full quizzes available for a user.
  # Purchased by the user.
  def available_full_quizzes
    
    # TODO: Filter the quizzes here based on the rules.
    return self.quizzes.where(:quiz_type_id => QuizType.find_by_name("FullQuiz").id)
    
  end

  def verbal_average
    return 120
  end
  
  def verbal_highest
    return 130
  end
  
  def quant_highest
    return 150
  end
 
  def quant_average
    return 140
  end
  
  def overall_average
    return 320
  end
  
  def overall_highest
    return 340
  end
  
  def areas_of_improvement  
    return [ Topic.first, Topic.last, Category.first, Category.last ]
  end

end
