class OfferCode < ActiveRecord::Base
  attr_accessible :code, :desc
  validates :code, :uniqueness => true
end
