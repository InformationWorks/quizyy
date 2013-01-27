class Quiz < ActiveRecord::Base
  belongs_to :quiz_type
  belongs_to :category
  belongs_to :topic
  attr_accessible :name, :random, :quiz_type_id, :category_id, :topic_id,:desc
  
  validates :name,:desc,:slug,:price, :presence => true
  before_validation :generate_slug
  
  has_many :sections
  
  has_many :quiz_users
  has_many :users, :through => :quiz_users
  
  has_many :package_quizzes
  has_many :packages, :through => :package_quizzes
  
  belongs_to :publisher, :class_name => "User"
  belongs_to :approver, :class_name => "User"
  
  scope :full, :conditions => { :quiz_type_id => ( QuizType.find_by_name("FullName") != nil ? QuizType.find_by_name("FullQuiz").id : -1 ) }
  scope :timed, :conditions => { :timed => true }
  scope :practice, :conditions => { :timed => false }
  scope :free, :conditions => { :price => 0 }
  scope :paid, :conditions => ["price > 0"]
  scope :approved, :conditions => { :approved => true }
  scope :unapproved, :conditions => { :approved => false }
  scope :published, :conditions => { :published => true }
  scope :unpublished, :conditions => { :published => false }
  scope :not_in_account_of_user, lambda { |user| {:conditions => ["id not in (?)", user.quizzes.pluck('quizzes.id')]} }
  
  def self.scoped_timed_full_quizzes(user)
    if user == nil 
      Quiz.full.timed.approved
    elsif user.role?(:super_admin) || user.role?(:admin) 
      Quiz.full.timed.published
    elsif user.role?(:publisher)
      Quiz.full.timed.published
    else
      Quiz.full.timed.approved
    end
  end
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug = name.parameterize
  end
  
end
