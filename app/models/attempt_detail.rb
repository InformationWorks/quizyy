##
# This class represents an AttemptDetail
class AttemptDetail < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :attempt_id,:question_id,:option_id,:user_input,:marked
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :attempt
  belongs_to :question
  belongs_to :option
  
end
