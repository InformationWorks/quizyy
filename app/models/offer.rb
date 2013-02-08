class Offer < ActiveRecord::Base
  attr_accessible :active, :code, :credits, :desc, :global, :start, :stop, :title
  
  validates :active, :code, :credits, :desc, :global, :start, :stop, :title, :presence => true
  
  scope :add_credits_on_confirm, :conditions => { :code => "add_credits_on_confirm" }
  scope :active, :conditions => { :active => true }
end
