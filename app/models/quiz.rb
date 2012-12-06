class Quiz < ActiveRecord::Base
  belongs_to :quiz_type
  belongs_to :category
  belongs_to :topic
  attr_accessible :name, :random
end
