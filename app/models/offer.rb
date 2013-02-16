##
# This class represents an offer. Only active & valid offers
# are applied.
# 
# Below are currently implemented offers.
# 
# * <tt>add_credits_on_confirm</tt>
#
# => When active adds specified credits to the users account.
#
# * <tt>add_items_on_confirm</tt> - True if its valid. False otherwise.
#
# => When active adds specified items (quizzes/packages) from the 
# => OfferItem table to the users account.
#
# Below are a few notes about the Offers.
#
# * <tt>Global Offers</tt>
#
# => Global offers are applied to all users.
# => Non-global offers are only applied to
#    the users who belong to OfferUSer.  
#
class Offer < ActiveRecord::Base
  
  ############################################################
  # Basic setup
  ############################################################
  
  # ----------------------------------------------------------
  # Attributes
  
  attr_accessible :active, :offer_code_id, :credits, :desc, 
                  :global, :start, :stop, :title
  
  # ----------------------------------------------------------
  # Validations
  
  validates :offer_code_id, :credits, :desc, :start, :stop, 
            :title, :presence => true
  
  # ----------------------------------------------------------
  # Before-After Callbacks
  
  ############################################################
  # Relations
  ############################################################
  
  # ----------------------------------------------------------
  # belongs_to
  
  belongs_to :offer_code
  
  # ----------------------------------------------------------
  # has_many
  
  has_many :offer_users
  has_many :offer_items
  has_many :quizzes, :through => :offer_items
  has_many :packages, :through => :offer_items
  
  # ----------------------------------------------------------
  # has_many :through
  
  ############################################################
  # Scopes
  ############################################################
  
  # ----------------------------------------------------------
  # Direct scopes
  
  scope :add_credits_on_confirm_offers, :conditions => { :offer_code_id => OfferCode.find_by_code("add_credits_on_confirm") }
  scope :add_items_on_confirm_offers, :conditions => { :offer_code_id => OfferCode.find_by_code("add_items_on_confirm") }
  
  # ----------------------------------------------------------
  # Lambda scopes
  
  scope :active, lambda { 
    { :conditions => ["? BETWEEN start AND stop AND active = true",DateTime.now] } 
  }
  
  ###########################################################
  # Functions
  ############################################################
  
  # ----------------------------------------------------------
  # Overrides
  
  # ----------------------------------------------------------
  # Instance methods
  
  # Check if the offer is valid for the provided email
  #
  # ==== Returns
  # * <tt>offer_validity</tt> - True if its valid. False otherwise.
  def valid_for_email?(email)
    
    if self.offer_users.find_by_email(email) == nil
      return false
    end
    
    return true
  end
 
  # ----------------------------------------------------------
  # Class methods
  
end
