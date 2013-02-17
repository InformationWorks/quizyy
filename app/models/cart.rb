##
# This class represents a Cart.
#
# A cart has multiple CartItem's. At a time only one cart
# can be in the db for a user. If a cart exists for a user
# it is used or else a new cart is creted.
# 
class Cart < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :user_id
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :user
  
  # ----------------------------------------------------------
  # has_many
  
  has_one :order
  has_many :cart_items, :dependent => :destroy
  has_many :quizzes, :through => :cart_items
  has_many :packages, :through => :cart_items
  
end
