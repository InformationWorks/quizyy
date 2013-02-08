class OfferUser < ActiveRecord::Base
  belongs_to :offer
  belongs_to :user
  # attr_accessible :title, :body
end
