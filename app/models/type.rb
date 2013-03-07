##
# This class represents a question type.
# 
# Below are the question types required for GRE.
#
#  #  Code        Name
# =======================================================
# 01  V-MCQ-1     Choose 1 from 5
# 02  V-MCQ-2     Choose 1 or more from 3
# 03  V-SIP       Select in passage
# 04  V-TC-1      1 blank, 5 choices, 1 correct
# 05  V-TC-2      2 blanks, 3 choices / blank
# 06  V-TC-3      3 blanks, 3 choices / blank
# 07  V-SE        1 blank, 6 choices, 2 correct
# 08  Q-QC        Compare A - B, 4 choices, 1 correct
# 09  Q-MCQ-1     Choose 1 from 5
# 10  Q-MCQ-2     Choose 1 or more from n
# 11  Q-NE-1      Numerical Entry, 1 TextBox
# 12  Q-NE-2      Numerical Entry, 2 TextBox
# 13  Q-DI-MCQ-1  Data Interpretation + Q-MCQ-1
# 14  Q-DI-MCQ-2  Data Interpretation + Q-MCQ-2
# 15  Q-DI-NE-1   Data Interpretation + Q-DI-NE-1
# 16  Q-DI-NE-2   Data Interpretation + Q-DI-NE-2
#
class Type < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :code, :name, :category_id
  
  # ----------------------------------------------------------
  # Validations
  
  validates :code, :slug, :name, :presence => true
  validates :code, :slug, :name, :uniqueness => true
  
  # ----------------------------------------------------------
  # Before-After Callbacks
  
  before_validation :generate_slug
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :category
  
  # ----------------------------------------------------------
  # has_many
  
  # ----------------------------------------------------------
  # has_many :through
  
  ############################################################
  # Scopes
  ############################################################
  
  # ----------------------------------------------------------
  # Direct scopes
  
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
    self.slug = code.parameterize
  end
  
end
