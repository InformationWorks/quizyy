class Section < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :section_type
  attr_accessible :name, :sequence_no,:section_type_id,:display_text
  has_many :questions,:dependent => :destroy
  scope :with_all_association_data, includes({:questions=>[:options,:type]},:section_type).order('sections.sequence_no')
  
  validates :name, :sequence_no, :quiz_id, :section_type_id , :slug, :presence => true
  before_validation :generate_slug
  
  scope :verbal, :conditions => { :section_type_id => ( SectionType.find_by_name("Verbal") != nil ? SectionType.find_by_name("Verbal").id : -1 ) }
  scope :quant, :conditions => { :section_type_id => ( SectionType.find_by_name("Quant") != nil ? SectionType.find_by_name("Quant").id : -1 ) }
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug = name.parameterize
  end
end
