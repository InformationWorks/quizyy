class OfferItem < ActiveRecord::Base
  belongs_to :offer
  belongs_to :quiz
  belongs_to :package
  # attr_accessible :title, :body
end
