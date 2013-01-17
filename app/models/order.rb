class Order < ActiveRecord::Base
  attr_accessible :cart_id, :responseCode, :responseDescription
  belongs_to :cart 
end
