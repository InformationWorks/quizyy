##
# This class represents a quiz. A quiz has section/sections.
# Sections further have questions & questions have options.
class Quiz < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :name, :random, :quiz_type_id, :category_id, :topic_id,:desc,:section_type_id
  attr_accessor :word
  
  # ----------------------------------------------------------
  # Validations
  
  validates :name,:desc,:slug,:price, :presence => true
  
  # ----------------------------------------------------------
  # Before-After Callbacks
  
  before_validation :generate_slug
  before_save :set_timed
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :quiz_type
  belongs_to :category
  belongs_to :topic
  belongs_to :section_type
  belongs_to :publisher, :class_name => "User"
  belongs_to :approver, :class_name => "User"
  
  # ----------------------------------------------------------
  # has_many
  
  has_many :sections
  has_many :quiz_users
  has_many :package_quizzes
  
  # ----------------------------------------------------------
  # has_many :through
  
  has_many :questions, :through => :sections
  has_many :users, :through => :quiz_users
  has_many :packages, :through => :package_quizzes
  
  ############################################################
  # Scopes
  ############################################################
  
  # ----------------------------------------------------------
  # Direct scopes
  
  scope :full, :conditions => { :quiz_type_id => QuizType.find_by_name("FullQuiz") }
  scope :category, :conditions => { :quiz_type_id => QuizType.find_by_name("CategoryQuiz") }
  scope :topic, :conditions => { :quiz_type_id => QuizType.find_by_name("TopicQuiz") }
  scope :section, :conditions => { :quiz_type_id => QuizType.find_by_name("SectionQuiz") }
  scope :verbal, :conditions => { :section_type_id => SectionType.find_by_name("Verbal") }
  scope :quant, :conditions => { :section_type_id => SectionType.find_by_name("Quant") }
  scope :free, :conditions => { :price => 0 }
  scope :paid, :conditions => ["price > 0"]
  scope :approved, :conditions => { :approved => true }
  scope :unapproved, :conditions => { :approved => false }
  scope :published, :conditions => { :published => true }
  scope :unpublished, :conditions => { :published => false }
  
  # ----------------------------------------------------------
  # Lambda scopes
  
  # Scope to return quizzes not in account of the user.
  # For guest users => return   
  scope :not_in_account_of_user, lambda { |user| 
    
    # For user's who haven't logged in.
    if user == nil
      return
    end
    
    user_quiz_ids = user.quizzes.pluck('quizzes.id')
    if user_quiz_ids == []
      return
    else
      return { :conditions => ["id not in (?)", user_quiz_ids] }  
    end
  }
  
  # Excludes quizzes passed in as relation. 
  scope :excluding, lambda { |quizzes|
    quiz_ids = quizzes.pluck('quizzes.id')
    if quiz_ids == []
      return
    else
      return { :conditions => ["id not in (?)", quiz_ids] }  
    end
  }
  
  # Only return quizzes for a specific categroy
  # Be careful and don't pass 'nil' as category. 
  # If 'nil' is passed, it will generate below query.
  # SELECT "quizzes".* FROM "quizzes" WHERE "quizzes"."category_id" IS NULL
  # category_id is nil for non-category quizzes too. Never pass 'nil' 
  scope :specific_category, lambda { |category| 
    return { :conditions => { :category_id => category } }  
  }
  
  # Only return quizzes for a specific topic
  # Be careful and don't pass 'nil' as topic. 
  # If 'nil' is passed, it will generate below query.
  # SELECT "quizzes".* FROM "quizzes" WHERE "quizzes"."topic_id" IS NULL
  # topic_id is nil for non-topic quizzes too. Never pass 'nil'
  scope :specific_topic, lambda { |topic| 
    return { :conditions => { :topic_id => topic } }  
  }
  
  # Only show quizzes that a user is supposed to see in store based on roles.
  # Normal user & Guest user => Only approved.
  # Super Admin & Admin => Any published quiz, even if it is not approved.
  # Publisher => All quizzes. 
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
  
  ###########################################################
  # Functions
  ############################################################
  
  # ----------------------------------------------------------
  # Overrides
  
  # Use slug for generating path/url.
  def to_param
    slug
  end
  
  # ----------------------------------------------------------
  # Instance methods
  
  # Use slug for generating path/url.
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
  
  # ----------------------------------------------------------
  # Class methods
  
  # Calculate revenue generated by passed quizzes.
  def self.revenue_and_purchases_for_quizzes(quizzes)
    
    revenue = 0
    purchases = 0
    quizzes.each do |quiz|
      user_count = quiz.users.count
      if user_count > 0
        purchases += user_count
        revenue += (quiz.price * user_count)
      end
    end
    
    return revenue, purchases
  end
  
  # Fetch full quizzes to be displayed in the store.
  # return full_length_quizzes,purchased_full_length_quizzes
  def self.store_full_quizzes(user)
    
    full_quizzes = Quiz.scoped_for_user(user).not_in_account_of_user(user).full.order('id ASC')
    
    # Logged in users.
    if user != nil
      purchased_full_quizzes = user.quizzes.full
      purchased_full_quizzes_count = purchased_full_quizzes.count
      full_quizzes += purchased_full_quizzes
    else
      purchased_full_quizzes_count = 0
    end
    
    return full_quizzes,purchased_full_quizzes_count
  end
  
  # Fetch verbal section quizzes to be displayed in the store.
  def self.store_verbal_section_quizzes(user)
    
    verbal_section_quizzes = Quiz.scoped_for_user(user).not_in_account_of_user(user).section.verbal.order('id ASC')
    
    # Logged in users.
    if user != nil
      purchased_verbal_section_quizzes = user.quizzes.section.verbal
      verbal_section_quizzes += purchased_verbal_section_quizzes
    end
    
    return verbal_section_quizzes
  end
  
  # Fetch quant section quizzes to be displayed in the store.
  def self.store_quant_section_quizzes(user)
    
    quant_section_quizzes = Quiz.scoped_for_user(user).not_in_account_of_user(user).section.quant.order('id ASC')
    
    # Logged in users.
    if user != nil
      purchased_quant_section_quizzes = user.quizzes.section.quant
      quant_section_quizzes += purchased_quant_section_quizzes
    end
    
    return quant_section_quizzes
  end
  
  # Fetch quizzes to be displayed in the store for a category.
  #
  # ==== Parameters
  # * <tt>user</tt> - User to scope the quizzes to be displayed in store.
  # * <tt>category</tt> - Category for which quizzes need to be fetched.
  #
  # ==== Returns
  # * <tt>category_quizzes</tt> - quizzes to be displayed in the store for a Category.
  def self.store_category_quizzes(user,category)
    
    category_quizzes = Quiz.scoped_for_user(user).not_in_account_of_user(user).category.specific_category(category).order('id ASC')
    
    if user != nil
      category_quizzes += current_user.quizzes.category.specific_category(category)  
    end
    
    return category_quizzes
    
  end
  
  # Fetch quizzes to be displayed in the store for a topic.
  #
  # ==== Parameters
  # * <tt>user</tt> - User to scope the quizzes to be displayed in store.
  # * <tt>topic</tt> - Topic for which quizzes need to be fetched.
  #
  # ==== Returns
  # * <tt>topic_quizzes</tt> - Quizzes to be displayed in the store for a Topic.
  def self.store_topic_quizzes(user,topic)
    
    topic_quizzes = Quiz.scoped_for_user(user).not_in_account_of_user(user).topic.specific_topic(topic).order('id ASC')
    
    if user != nil
      topic_quizzes += current_user.quizzes.topic.specific_topic(topic)  
    end
    
    return topic_quizzes
    
  end
  
  # Generate a array of special datastructure for store.
  #
  # ==== Parameters
  # * <tt>entity</tt> - "category" or "topic" string.
  # * <tt>user</tt> - User to scope the quizzes to be displayed in store.
  #
  # ==== Returns
  # * { entity => string, name => string, slug => string , quizzes => array_of_quizzes }
  def self.store_entity_name_quizzes(entity,user)
    
    # Fetch the quizzes not owned by user first and then append owned quizzes.
    if entity == "Category"
      
      if user == nil
        quizzes = Quiz.category.approved.order('id ASC')
      else
        quizzes = Quiz.scoped_for_user(user).not_in_account_of_user(user).category.order('id ASC')
        quizzes += user.quizzes.category
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
      
      if user == nil
        quizzes = Quiz.topic.approved.order('id ASC')
      else
        quizzes = Quiz.scoped_for_user(user).not_in_account_of_user(user).topic.order('id ASC')
        quizzes += user.quizzes.topic
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
