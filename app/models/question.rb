class Question < ActiveRecord::Base
  
  include ApplicationHelper
  
  belongs_to :type
  belongs_to :topic
  belongs_to :section
  attr_accessible :di_location, :header, :instruction, :option_set_count, :passage, :quantity_a, :quantity_b, :que_image, :que_text, :sequence_no, :sol_image, :sol_text,:type_id,:topic_id
  has_many :options,:dependent => :destroy
  
  def to_param
    sequence_no
  end
  
  def que_image_url
    
    if ( self.que_image == nil )
      return nil
    end
    
    "#{s3_base_url}/uploads/quiz/#{self.section.quiz.id}/quiz_question_images/#{self.que_image}"
  end
  
  def sol_image_url
    
    if ( self.sol_image == nil )
      return nil
    end
    
    "#{s3_base_url}/uploads/quiz/#{self.section.quiz.id}/quiz_question_images/#{self.sol_image}"
  end
  
end
