##
# This class represents a devise User.
class User < ActiveRecord::Base
  
  delegate :can?, :cannot?, :to => :ability
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  mount_uploader :profile_image, ProfileImageUploader
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :full_name, :profile_image, 
                  :credits
  
  # ----------------------------------------------------------
  # Validations
  
  validates :full_name,  :presence => true
  
  # ----------------------------------------------------------
  # Before-After Callbacks
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  # ----------------------------------------------------------
  # has_one & has_many
  
  has_many :role_users
  has_many :quiz_users
  has_many :carts
  has_many :published_quizzes, :class_name => "Quiz", :foreign_key => "publisher_id"
  has_many :approved_quizzes, :class_name => "Quiz", :foreign_key => "approver_id"
  
  # ----------------------------------------------------------
  # has_many :through
  
  has_many :orders, :through => :carts
  has_many :roles, :through => :role_users
  has_many :quizzes, :through => :quiz_users
  
  ############################################################
  # Scopes
  ############################################################
  
  # ----------------------------------------------------------
  # Direct scopes
	# The following scopes are not correct they cause issues in mirgation
  # scope :non_students,:include => :roles ,:conditions => ["roles.id <> ?",Role.find_by_name("Student")] 
	# scope :students, :include => :roles, :conditions => { "roles.id" => Role.find_by_name("Student") }

  # ----------------------------------------------------------
  # Lambda scopes
  
  ###########################################################
  # Functions
  ############################################################
  
  # ----------------------------------------------------------
  # Overrides
  
  # ----------------------------------------------------------
  # Instance methods
  
  # Check if the User has a role.
  def role?(role)
    
    if ( self.roles.find_by_name(role.to_s.camelize) == nil )
      return false
    else
      return true
    end
    
  end
  
  # Check if the User has ability to administer the app.
  def can_administer?
    
    if ( authorize! :administer, :app )
      return true
    else
      return false
    end
    
  end
  
  def verbal_average
    (Attempt.section_scores_for_user(self.id)[:verbal][:avg]).to_i
  end
  
  def verbal_highest
    (Attempt.section_scores_for_user(self.id)[:verbal][:max]).to_i
  end
  
  def quant_highest
    (Attempt.section_scores_for_user(self.id)[:quant][:max]).to_i
  end
 
  def quant_average
    (Attempt.section_scores_for_user(self.id)[:quant][:avg]).to_i
  end
  
  def overall_average
    Attempt.avg_score_for_user(self.id).to_i
  end
  
  def overall_highest
    Attempt.max_score_for_user(self.id).to_i
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
  
  # Add credits and log the activity.
  def add_credits(credits,actor_id,action,target_id,activity)
    # Add credits.
    self.credits += credits
    self.save!
    
    # Log the add credits activity.
    activity_log = ActivityLog.new
    activity_log.actor_id = actor_id
    activity_log.action = action
    activity_log.target_id = target_id
    activity_log.activity = activity
  end
  
  # Add quiz and log the activity.
  def add_quiz(quiz,actor_id,action,target_id,activity)
    
    # Add quiz.
    quiz_user = QuizUser.new
    quiz_user.user_id = self.id
    quiz_user.quiz_id = quiz.id
    quiz_user.save!
    
    # Log the add credits activity.
    activity_log = ActivityLog.new
    activity_log.actor_id = actor_id
    activity_log.action = action
    activity_log.target_id = target_id
    activity_log.activity = activity
  end
  
  # Add package and log the activity.
  def add_package(package,actor_id,action,target_id,activity)
    
    # Add package.
    package.quizzes.pluck(:quiz_id).each do |quiz_id|
      quiz_user = QuizUser.new
      quiz_user.user_id = self.id
      quiz_user.quiz_id = quiz_id
      quiz_user.save!
    end
    
    # Log the add credits activity.
    activity_log = ActivityLog.new
    activity_log.actor_id = actor_id
    activity_log.action = action
    activity_log.target_id = target_id
    activity_log.activity = activity
  end
 
  # ----------------------------------------------------------
  # Class methods
  
  private
  
  # Devise password required override.
  #def password_required?
  #  super if confirmed?
  #end
  
  # Devise confirmable password match.  
  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
  
  # Ability delegate.
  def ability
    @ability ||= Ability.new(self)
  end

end
