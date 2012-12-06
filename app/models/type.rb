class Type < ActiveRecord::Base
  belongs_to :category
  attr_accessible :code, :name
end
