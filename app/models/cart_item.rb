##
# This class represents a CartItem.
#
# CartItem can be either a quiz or a package. At a time only
# one of the quiz_id - package_id can be non-nil. The CartItem 
# belongs to a cart.
# 
class CartItem < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :quiz_id, :package_id, :cart_id
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :quiz
  belongs_to :package
  belongs_to :cart
  
end
