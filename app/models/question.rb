##
# This class represents a question.
class Question < ActiveRecord::Base
  
  include ApplicationHelper
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :di_location, :header, :instruction, :option_set_count, :passage, :quantity_a, :quantity_b, :que_image, :que_text, :sequence_no, :sol_image, :sol_text,:type_id,:topic_id
  
  # ----------------------------------------------------------
  # Validations
  
  # ----------------------------------------------------------
  # Before-After Callbacks
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :type
  belongs_to :topic
  belongs_to :section
  
  # ----------------------------------------------------------
  # has_many
  
  has_many :options,:dependent => :destroy
  
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
  
  # Builds the url of the question image.
  #
  #  s3_base_url is used to build the Amazon s3 part of the url
  # 
  # ==== Returns
  # * <tt>que_image_url</tt> - question image url.
  def que_image_url
    
    if ( self.que_image == nil )
      return nil
    end
    
    "#{s3_base_url}/uploads/quiz/#{self.section.quiz.id}/quiz_question_images/#{self.que_image}"
  end
  
  # Builds the url of the solution image.
  #
  #  s3_base_url is used to build the Amazon s3 part of the url
  # 
  # ==== Returns
  # * <tt>sol_image_url</tt> - solution image url.
  def sol_image_url
    
    if ( self.sol_image == nil )
      return nil
    end
    
    "#{s3_base_url}/uploads/quiz/#{self.section.quiz.id}/quiz_question_images/#{self.sol_image}"
  end
 
  # ----------------------------------------------------------
  # Class methods
  
  def to_param
    sequence_no
  end
  
end
