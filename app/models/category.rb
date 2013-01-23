class Category < ActiveRecord::Base
  attr_accessible :code, :name, :section_type_id
  has_many :quizzes
  
  validates :code,:name, :presence => true
  validates :code, :uniqueness => true
  validates :name, :uniqueness => true
  
  belongs_to :section_type
  
  # Select categories that have at-least 1 timed quiz associated to them.
  scope :with_timed_quiz_for_user, lambda { |user|
    if user == nil 
      joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.approved = true')
    elsif user.role?(:super_admin) || user.role?(:admin) 
      joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.published = true')
    elsif user.role?(:publisher)
      joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.published = true')
    else
      joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.approved = true')
    end
  }
  
  # Select categories that have at-least 1 practice quiz associated to them.
  scope :with_practice_quiz_for_user, lambda { |user|
    if user == nil 
      joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false AND quizzes.approved = true')
    elsif user.role?(:super_admin) || user.role?(:admin) 
      joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false AND quizzes.published = true')
    elsif user.role?(:publisher)
      joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false AND quizzes.published = true')
    else
      joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false AND quizzes.approved = true')
    end
  }
   
end
