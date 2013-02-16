##
# This class represents a package. A package is comprised of
# multiple quizzes.
#
# Below are currently implemented packages.
# 
# * <tt>Package 1</tt>
#
# => 5 Full-length quizzes.
#
# * <tt>Package 2</tt>
#
# => 7 Full-length quizzes.
#
# * <tt>Package 3</tt>
#
# => 10 Full-length quizzes.  
#
# Store package arrangement.
# 
#   # # # # # # # # # # # # # # # # # # # 
#   # Package 1 # Package 2 # Package 3 #
#   # # # # # # # # # # # # # # # # # # #
#
class Package < ActiveRecord::Base
  
  include ActiveModel::Validations
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :desc, :name, :price, :position
  
  # ----------------------------------------------------------
  # Validations
  
  validates :name,:slug,:position,:desc, :presence => true
  validates :name, :position, :uniqueness => true
  
  # ----------------------------------------------------------
  # Before-After Callbacks
  
  before_validation :generate_slug
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  # ----------------------------------------------------------
  # has_many
  
  has_many :package_quizzes
  has_many :quizzes, :through => :package_quizzes
  
  # ----------------------------------------------------------
  # has_many :through
  
  ############################################################
  # Scopes
  ############################################################
  
  # ----------------------------------------------------------
  # Direct scopes
  
  # ----------------------------------------------------------
  # Lambda scopes
  
  # Excludes packages passed to the scope.
  scope :excluding, lambda { |packages|
    package_ids = packages.pluck('packages.id')
    if package_ids == []
      return
    else
      return { :conditions => ["id not in (?)", package_ids] }  
    end
  }
  
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
  
end
