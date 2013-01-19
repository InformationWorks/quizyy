class Transaction < ActiveRecord::Base
  belongs_to :order
  belongs_to :user
  attr_accessible :action, :ipaddress, :responseCode, :responseDescription, :user_id, :order_id
end
