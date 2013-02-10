class OfferUser < ActiveRecord::Base
  belongs_to :offer
  attr_accessible :email
  validates_uniqueness_of :email, :scope => [:offer_id]
end
