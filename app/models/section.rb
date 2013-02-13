class Section < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :section_type
  attr_accessible :name, :sequence_no,:section_type_id,:display_text
  has_many :questions,:dependent => :destroy
  scope :with_all_association_data, includes({:questions=>[:options,:type]},:section_type).order('sections.sequence_no,questions.sequence_no,options.sequence_no')
  
  validates :name, :sequence_no, :quiz_id, :section_type_id , :slug, :presence => true
  before_validation :generate_slug
  before_save :set_time
  
  scope :verbal, :conditions => { :section_type_id => ( SectionType.find_by_name("Verbal") != nil ? SectionType.find_by_name("Verbal").id : -1 ) }
  scope :quant, :conditions => { :section_type_id => ( SectionType.find_by_name("Quant") != nil ? SectionType.find_by_name("Quant").id : -1 ) }
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug = name.parameterize
  end
  
  # Set the time for FullQuiz & SectionQuiz
  # 30 minutes: Verbal
  # 35 minutes: Quant
  def set_time
    
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
