class Quiz < ActiveRecord::Base
  belongs_to :quiz_type
  belongs_to :category
  belongs_to :topic
  belongs_to :section_type
  attr_accessible :name, :random, :quiz_type_id, :category_id, :topic_id,:desc,:section_type_id
  attr_accessor :word
  validates :name,:desc,:slug,:price, :presence => true
  before_validation :generate_slug
  before_save :set_timed
  
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
  scope :section, :conditions => { :quiz_type_id => ( QuizType.find_by_name("SectionQuiz") != nil ? QuizType.find_by_name("SectionQuiz").id : -1 ) }
  scope :verbal, :conditions => { :section_type_id => ( SectionType.find_by_name("Verbal") != nil ? SectionType.find_by_name("Verbal").id : -1 ) }
  scope :quant, :conditions => { :section_type_id => ( SectionType.find_by_name("Quant") != nil ? SectionType.find_by_name("Quant").id : -1 ) }
  scope :free, :conditions => { :price => 0 }
  scope :paid, :conditions => ["price > 0"]
  scope :approved, :conditions => { :approved => true }
  scope :unapproved, :conditions => { :approved => false }
  scope :published, :conditions => { :published => true }
  scope :unpublished, :conditions => { :published => false }
  scope :not_in_account_of_user, lambda { |user| 
    user_quiz_ids = user.quizzes.pluck('quizzes.id')
    if user_quiz_ids == []
      return
    else
      return { :conditions => ["id not in (?)", user_quiz_ids] }  
    end
  }
  scope :excluding, lambda { |quizzes|
    quiz_ids = quizzes.pluck('quizzes.id')
    if quiz_ids == []
      return
    else
      return { :conditions => ["id not in (?)", quiz_ids] }  
    end
  }
  scope :specific_category, lambda { |category| 
    return { :conditions => { :category_id => category.id } }  
  }
  scope :specific_topic, lambda { |topic| 
    return { :conditions => { :topic_id => topic.id } }  
  }
  scope :scoped_for_user, lambda { |user| 
    if user == nil 
      return { :conditions => { :approved => true } }
    elsif user.role?(:super_admin) || user.role?(:admin) 
      return { :conditions => { :published => true } }
    elsif user.role?(:publisher)
      return
    else
      return { :conditions => { :approved => true } }
    end
  }
  
  def self.revenue_and_purchases_for_quizzes(quizzes)
    
    revenue = 0
    purchases = 0
    quizzes.each do |quiz|
      user_count = quiz.users.count
      if user_count > 0
        purchases += 1
        revenue += (quiz.price * user_count)
      end
    end
    
    return revenue, purchases
  end
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug = name.parameterize
  end
  
  # Generate test_detail_path based on the type.
  def test_detail_path
    
    if self.quiz_type_id == QuizType.find_by_name("FullQuiz").id
      Rails.application.routes.url_helpers.show_full_test_path(self.slug)
    elsif self.quiz_type_id == QuizType.find_by_name("CategoryQuiz").id
      Rails.application.routes.url_helpers.show_category_test_path(self.category.slug,self.slug)
    elsif self.quiz_type_id == QuizType.find_by_name("TopicQuiz").id
      Rails.application.routes.url_helpers.show_topic_test_path(self.topic.slug,self.slug)
    elsif self.quiz_type_id == QuizType.find_by_name("SectionQuiz").id
      if self.section_type_id == SectionType.find_by_name("Verbal").id
        Rails.application.routes.url_helpers.show_verbal_test_path(self.slug)
      elsif self.section_type_id == SectionType.find_by_name("Quant").id
        Rails.application.routes.url_helpers.show_quant_test_path(self.slug)
      end
    end
    
  end
  
  # Generate a array of special datastructure for store.
  # structure: 
  # { entity => string, name => string, slug => string , quizzes => array_of_quizzes }
  def self.store_entity_name_quizzes(entity,user)
    
    # Fetch the quizzes not owned by user first and then append owned quizzes.
    if entity == "Category"
      
      quizzes = Quiz.scoped_for_user(user).not_in_account_of_user(user).category.order('id ASC')
      quizzes += user.quizzes.category
      
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
      
      quizzes = Quiz.scoped_for_user(user).not_in_account_of_user(user).topic.order('id ASC')
      quizzes += user.quizzes.topic
      
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
  
  # Set the timed flag as true for FullQuiz & SectionQuiz
  def set_timed
    
    if self.quiz_type_id == QuizType.find_by_name("FullQuiz").id
      self.timed = true
    elsif self.quiz_type_id == QuizType.find_by_name("SectionQuiz").id
      self.timed = true
    else
      self.timed = false
    end
    # This is required as the call_back will fail if false is returned.
    nil
  end
  
end
