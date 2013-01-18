class Order < ActiveRecord::Base
  attr_accessible :cart_id, :responseCode, :responseDescription
  belongs_to :cart
  
  def price
    quizzes_price = self.cart.quizzes.sum :price
    packages_price = self.cart.packages.sum :price
    quizzes_price + packages_price
  end
   
end
