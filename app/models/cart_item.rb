class CartItem < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :pacakge
  belongs_to :cart
  # attr_accessible :title, :body
end
