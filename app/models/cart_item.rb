class CartItem < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :package
  belongs_to :cart
  attr_accessible :quiz_id, :package_id, :cart_id
end
