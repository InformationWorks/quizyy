##
# This class represents a Section. Section belong to a quiz.
#
# => FullQuiz : [ 2 Verbal Sections, 2 Quant Sections ] 
# => CategoryQuiz : [ 1 Section ]
# => TopicQuiz : [ 1 Section ]
# => SectionQuiz : [ 1 Section ]
#
# Currently implemented SectionType's are listed below.
#
# => Verbal
# => Quant
#
class Section < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :name, :sequence_no,:section_type_id,:display_text
  
  # ----------------------------------------------------------
  # Validations
  
  validates :name, :sequence_no, :quiz_id, :section_type_id , :slug, :presence => true
  
  # ----------------------------------------------------------
  # Before-After Callbacks
  
  before_validation :generate_slug
  before_save :set_time_before_save
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :quiz
  belongs_to :section_type
  
  # ----------------------------------------------------------
  # has_many
  
  has_many :questions,:dependent => :destroy
  
  # ----------------------------------------------------------
  # has_many :through
  
  ############################################################
  # Scopes
  ############################################################
  
  # ----------------------------------------------------------
  # Direct scopes
  
  scope :with_all_association_data, includes({:questions=>[:options,:type]},:section_type).order('sections.sequence_no,questions.sequence_no,options.sequence_no')
  scope :verbal, :conditions => { :section_type_id => SectionType.find_by_name("Verbal") }
  scope :quant , :conditions => { :section_type_id => SectionType.find_by_name("Quant") }
  
  # ----------------------------------------------------------
  # Lambda scopes
  
  ###########################################################
  # Functions
  ############################################################
  
  # ----------------------------------------------------------
  # Overrides
  
  # ----------------------------------------------------------
  # Instance methods
 
  # ----------------------------------------------------------
  # Class methods

  def to_param
    slug
  end
  
  private
  
  def generate_slug
    self.slug = name.parameterize
  end
  
  # Set the time for the quiz before saving.
  # 30 minutes: Verbal
  # 35 minutes: Quant
  #
  def set_time_before_save
    
    if self.quiz.quiz_type_id == QuizType.find_by_name("FullQuiz").id
      if self.section_type_id == SectionType.find_by_name("Quant").id
        self.time = 35
      elsif self.section_type_id == SectionType.find_by_name("Verbal").id
        self.time = 30
      end
    elsif self.quiz.quiz_type_id == QuizType.find_by_name("SectionQuiz").id
      if self.section_type_id == SectionType.find_by_name("Quant").id
        self.time = 35
      elsif self.section_type_id == SectionType.find_by_name("Verbal").id
        self.time = 30
      end
    else
      self.time = 0  
    end
    
    # This is required as the call_back will fail if false is returned.
    nil
    
  end
  
end
