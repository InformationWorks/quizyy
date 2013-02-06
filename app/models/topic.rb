class Topic < ActiveRecord::Base
  attr_accessible :name, :section_type_id
  has_many :quizzes
  
  validates :name, :slug, :presence => true
  validates :name, :uniqueness => true
  before_validation :generate_slug
  belongs_to :section_type
  # Select topics that have at-least 1 timed quiz associated to them.
  scope :with_timed_quiz_for_user, lambda { |user|
    if user == nil 
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.approved = true')
    elsif user.role?(:super_admin) || user.role?(:admin) 
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true AND quizzes.published = true')
    elsif user.role?(:publisher)
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true')
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
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false')
    else
      joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = false AND quizzes.approved = true')
    end
  }

  scope :timed_quizzes, lambda {|user,topic_ids|
    if user == nil
      includes(:quizzes).where('quizzes.timed = true AND quizzes.approved = true AND topics.id in (?)', topic_ids)
    elsif user.role?(:super_admin) || user.role?(:admin)
      includes(:quizzes).where('quizzes.timed = true AND quizzes.published = true AND topics.id in (?)', topic_ids)
    elsif user.role?(:publisher)
      includes(:quizzes).where('quizzes.timed = true AND topics.id in (?)', topic_ids)
    else
      includes(:quizzes).where('quizzes.timed = true AND quizzes.approved = true AND topics.id in (?)', topic_ids)
    end
  }

  scope :practice_quizzes, lambda {|user,topic_ids|
    if user == nil
      includes(:quizzes).where('quizzes.timed = false AND quizzes.approved = true AND topics.id in (?)', topic_ids)
    elsif user.role?(:super_admin) || user.role?(:admin)
      includes(:quizzes).where('quizzes.timed = false AND quizzes.published = true AND topics.id in (?)', topic_ids)
    elsif user.role?(:publisher)
      includes(:quizzes).where('quizzes.timed = false AND topics.id in (?)', topic_ids)
    else
      includes(:quizzes).where('quizzes.timed = false AND quizzes.approved = true AND topics.id in (?)', topic_ids)
    end
  }
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug = name.parameterize
  end
  
end
