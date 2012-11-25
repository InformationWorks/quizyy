class RoleUser < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :role
  belongs_to :user
end
