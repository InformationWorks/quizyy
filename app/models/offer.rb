class Offer < ActiveRecord::Base
  attr_accessible :active, :offer_code_id, :credits, :desc, :global, :start, :stop, :title
  
  validates :active, :offer_code_id, :credits, :desc, :global, :start, :stop, :title, :presence => true
  
  belongs_to :offer_code
  
  has_many :offer_users
  has_many :users, :through => :offer_users
  
  has_many :offer_items
  has_many :quizzes, :through => :offer_items
  
  has_many :offer_items
  has_many :packages, :through => :offer_items
  
  scope :add_credits_on_confirm_offers, lambda {  
    where("offer_code_id = ?", OfferCode.find_by_code("add_credits_on_confirm"))
  }
  
  scope :add_items_on_confirm_offers, lambda {  
    where("offer_code_id = ?", OfferCode.find_by_code("add_items_on_confirm"))
  }
    
  scope :active, lambda { 
    { :conditions => ["? BETWEEN start AND stop AND active = true",DateTime.now] } 
  }
  
  def valid_for_user?(user)
    # TODO: Implement offer_users table and check from that.
    return true
  end
end
