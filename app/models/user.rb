class User < ActiveRecord::Base
  
  delegate :can?, :cannot?, :to => :ability
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # TODO: :confirmable to be added
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name, :profile_image, :credits
  # attr_accessible :title, :body
  
  mount_uploader :profile_image, ProfileImageUploader
  
  validates :full_name,  :presence => true
  
  has_many :role_users
  has_many :roles, :through => :role_users
  
  has_many :quiz_users
  has_many :quizzes, :through => :quiz_users
  
  has_many :carts
  has_many :orders, :through => :carts
  
  has_many :published_quizzes, :class_name => "Quiz", :foreign_key => "publisher_id"
  has_many :approved_quizzes, :class_name => "Quiz", :foreign_key => "approver_id"
  
  def role?(role)
    
    if ( self.roles.find_by_name(role.to_s.camelize) == nil )
      return false
    else
      return true
    end
    
  end
  
  # Check if the user has ability to administer the app.
  def can_administer?
    
    if ( authorize! :administer, :app )
      return true
    else
      return false
    end
    
  end
  
  # Devise password required override.
  def password_required?
    super if confirmed?
  end
  
  # Devise confirmable password match.  
  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  # Return an array of full quizzes available for a user.
  # Purchased by the user.
  def purchased_full_quizzes
    
    # TODO: Filter the quizzes here based on the rules.
    return self.quizzes.where(:quiz_type_id => QuizType.find_by_name("FullQuiz").id)
    
  end
  
  # Return an array of Category+Topic quizzes available for a user.
  # Purchased by the user.
  def purchased_category_topic_quizzes
    
    category_quiz_type_id = QuizType.find_by_name("CategoryQuiz").id
    topic_quiz_type_id = QuizType.find_by_name("TopicQuiz").id
    
    # TODO: Filter the quizzes here based on the rules.
    return self.quizzes.where("quiz_type_id = #{category_quiz_type_id} OR quiz_type_id = #{topic_quiz_type_id}")
    
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
  
  # Return true if user has purchased the quiz.
  def has_purchased_quiz?(quiz_id)
    
    if QuizUser.where(:quiz_id => quiz_id,:user_id => self.id).count == 0
      return false
    else
      return true
    end
    
  end
  
  # Return true if user has the quiz in his cart.
  def has_quiz_in_cart?(quiz_id)
    
    if get_cart_item_id_for_quiz(quiz_id) == -1
      return false
    else
      return true
    end
    
  end
  
  # Return cart_item id for a user's quiz.
  # -1 if cart_item does not exist for a quiz.
  def get_cart_item_id_for_quiz(quiz_id)
    cart = Cart.where(:user_id => self.id).first
     
    if cart == nil
      return -1
    else
      
      cart_item = cart.cart_items.where(:quiz_id => quiz_id).first 
      
      if cart_item == nil
        return -1
      else
        return cart_item.id
      end
      
    end
  end
  
  # Return cart_item id for a user's package.
  # -1 if cart_item does not exist for a package.
  def get_cart_item_id_for_package(package_id)
    cart = Cart.where(:user_id => self.id).first
     
    if cart == nil
      return -1
    else
      
      cart_item = cart.cart_items.where(:package_id => package_id).first 
      
      if cart_item == nil
        return -1
      else
        return cart_item.id
      end
      
    end
  end
  
  private
  
  def ability
    @ability ||= Ability.new(self)
  end

end
