class Quiz < ActiveRecord::Base
  belongs_to :quiz_type
  belongs_to :category
  belongs_to :topic
  attr_accessible :name, :timed, :random, :quiz_type_id, :category_id, :topic_id,:desc
  attr_accessor :word
  validates :name,:desc,:slug,:price, :presence => true
  before_validation :generate_slug
  
  has_many :sections
  has_many :questions, :through => :sections
  
  has_many :quiz_users
  has_many :users, :through => :quiz_users
  
  has_many :package_quizzes
  has_many :packages, :through => :package_quizzes
  
  belongs_to :publisher, :class_name => "User"
  belongs_to :approver, :class_name => "User"
  
  scope :full, :conditions => { :quiz_type_id => ( QuizType.find_by_name("FullQuiz") != nil ? QuizType.find_by_name("FullQuiz").id : -1 ) }
  scope :category, :conditions => { :quiz_type_id => ( QuizType.find_by_name("CategoryQuiz") != nil ? QuizType.find_by_name("CategoryQuiz").id : -1 ) }
  scope :topic, :conditions => { :quiz_type_id => ( QuizType.find_by_name("TopicQuiz") != nil ? QuizType.find_by_name("TopicQuiz").id : -1 ) }
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
      Quiz.full.timed
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
  
  # Generate a array of special datastructure for store.
  # structure: 
  # { entity => string, name => string, slug => string , quizzes => array_of_quizzes }
  def self.store_entity_name_quizzes(entity,timed,user)
    
    # Fetch the quizzes not owned by user first and then append owned quizzes.
    if entity == "Category"
      if timed
        quizzes = Quiz.not_in_account_of_user(user).category.timed.order('id ASC')
        quizzes += user.quizzes.category.timed
      else
        quizzes = Quiz.not_in_account_of_user(user).category.practice.order('id ASC')
        quizzes += user.quizzes.category.practice
      end
      
      # Club all quizzes based on categories.
      # {  
      #    "RC" => [ quiz1, quiz2 ],
      #    "TC" => [ quiz3, quiz4]
      # }
      name_quizzes_hash = {}
      name_slug_hash = {}
      quizzes.each do |quiz|
        if name_quizzes_hash[quiz.category.name] == nil
          name_quizzes_hash[quiz.category.name] = []
        end
        name_quizzes_hash[quiz.category.name] << quiz
        name_slug_hash[quiz.category.name] = quiz.category.slug
      end
    else
      if timed
        quizzes = Quiz.not_in_account_of_user(user).topic.timed.order('id ASC')
        quizzes += user.quizzes.topic.timed
      else
        quizzes = Quiz.not_in_account_of_user(user).topic.practice.order('id ASC')
        quizzes += user.quizzes.topic.practice
      end
      
      # Club all quizzes based on topics.
      # {  
      #    "RC" => [ quiz1, quiz2 ],
      #    "TC" => [ quiz3, quiz4]
      # }
      name_quizzes_hash = {}
      name_slug_hash = {}
      quizzes.each do |quiz|
        if name_quizzes_hash[quiz.topic.name] == nil
          name_quizzes_hash[quiz.topic.name] = []
        end
        name_quizzes_hash[quiz.topic.name] << quiz
        name_slug_hash[quiz.topic.name] = quiz.topic.slug
      end
    end
    
    # Generate the special structure with entity
    # [
    # { "Category" , "RC" , [ quiz1, quiz2 ] }, 
    # { "Category" , "TC" , [ quiz3, quiz4 ] } 
    # ]
    entity_name_quizzes = []
    name_quizzes_hash.each do |name,quizzes_array|
      entity_name_quizzes << { :entity => entity, :name => name, :slug => name_slug_hash[name] ,:quizzes => quizzes_array } 
    end
    
    return entity_name_quizzes
    
  end
  
end
