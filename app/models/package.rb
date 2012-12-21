# position = 1 => Left
# position = 2 => Center
# position = 3 => Right
class Package < ActiveRecord::Base
  attr_accessible :desc, :name, :price, :position
  
  include ActiveModel::Validations
  validates :name,:position,:desc, :presence => true
  validate :position_cannot_be_repeated
  
  has_many :package_quizzes
  has_many :quizzes, :through => :package_quizzes
  
  # Custom validation
  def position_cannot_be_repeated
    
     logger.info("id = " + id.to_s)
    
     if id
      # Updating package.
      if Package.where("id != " << id.to_s << " and position = " << position.to_s).count > 0
        errors[:position] << 'already taken. Only one package can have position ' + position.to_s
      end
    else
      # Creating package.
      if Package.find_by_position(position)
        errors[:position] << 'already taken. Only one package can have position ' + position.to_s
      end
    end
    
  end
  
end
