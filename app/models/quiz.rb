class Quiz < ActiveRecord::Base
  belongs_to :quiz_type
  belongs_to :category
  belongs_to :topic
  attr_accessible :name, :random, :quiz_type_id, :category_id, :topic_id
end
