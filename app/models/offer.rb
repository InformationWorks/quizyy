class Offer < ActiveRecord::Base
  attr_accessible :active, :code, :credits, :desc, :global, :start, :stop, :title
  
  validates :active, :code, :credits, :desc, :global, :start, :stop, :title, :presence => true
  
  scope :add_credits_on_confirm, :conditions => { :code => "add_credits_on_confirm" }
    
  scope :active, lambda { 
    { :conditions => ["? BETWEEN start AND stop AND active = true",DateTime.now] } 
  }
  
  def valid_for_user?(user)
    # TODO: Implement offer_users table and check from that.
    return true
  end
end
