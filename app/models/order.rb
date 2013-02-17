##
# This class represents an Order. An order has multiple items
# that include quizzes & packages.
class Order < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :cart_id, :responseCode, :responseDescription
  
  # ----------------------------------------------------------
  # Validations
  
  # ----------------------------------------------------------
  # Before-After Callbacks
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :cart
  
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
 
  # Calculate total price of the order.
  #
  # ==== Returns
  # * <tt>price</tt> - Return the total price of the order.
  def price
    quizzes_price = self.cart.quizzes.sum :price
    packages_price = self.cart.packages.sum :price
    quizzes_price + packages_price
  end
 
  # ----------------------------------------------------------
  # Class methods
   
end
