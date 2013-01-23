class Topic < ActiveRecord::Base
  attr_accessible :name
  has_many :quizzes
  
  validates :name, :presence => true
  validates :name, :uniqueness => true
  
  # Select topics that have at-least 1 timed quiz associated to them.
  scope :with_timed_quiz_for_user, lambda { |user|
    if user == nil 
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.approved = true')
    elsif user.role?(:super_admin) || user.role?(:admin) 
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.published = true')
    elsif user.role?(:publisher)
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.published = true')
    else
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.approved = true')
    end
  }
  
  # Select topics that have at-least 1 practice quiz associated to them.
  scope :with_practice_quiz_for_user, lambda { |user|
    if user == nil 
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false AND quizzes.approved = true')
    elsif user.role?(:super_admin) || user.role?(:admin) 
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false AND quizzes.published = true')
    elsif user.role?(:publisher)
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false AND quizzes.published = true')
    else
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false AND quizzes.approved = true')
    end
  }
  
  def scoped_timed_quizzes(user)
    if user == nil 
      self.quizzes.where('quizzes.timed = true AND quizzes.approved = true')
    elsif user.role?(:super_admin) || user.role?(:admin) 
      self.quizzes.where('quizzes.timed = true AND quizzes.published = true')
    elsif user.role?(:publisher)
      self.quizzes.where('quizzes.timed = true AND quizzes.approved = true')
    else
      self.quizzes.where('quizzes.timed = true AND quizzes.approved = true')
    end
  end
  
  def scoped_practice_quizzes(user)
    if user == nil 
      self.quizzes.where('quizzes.timed = false AND quizzes.approved = true')
    elsif user.role?(:super_admin) || user.role?(:admin) 
      self.quizzes.where('quizzes.timed = false AND quizzes.published = true')
    elsif user.role?(:publisher)
      self.quizzes.where('quizzes.timed = false AND quizzes.approved = true')
    else
      self.quizzes.where('quizzes.timed = false AND quizzes.approved = true')
    end
  end
  
end
