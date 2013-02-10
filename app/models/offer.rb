class Offer < ActiveRecord::Base
  attr_accessible :active, :offer_code_id, :credits, :desc, :global, :start, :stop, :title
  
  validates :offer_code_id, :credits, :desc, :start, :stop, :title, :presence => true
  
  belongs_to :offer_code
  
  has_many :offer_users
  
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
  
  def valid_for_email?(email)
    
    if self.offer_users.find_by_email(email) == nil
      return false
    end
    
    return true
  end
end
