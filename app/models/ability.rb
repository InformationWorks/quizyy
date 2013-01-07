class Ability
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new # guest user
 
    if user.role? :super_admin
      # Roles for developers.
      can :manage, :all
    elsif user.role? :admin
      # Roles for admins to approve quiz.
      # can :manage, [Product, Asset, Issue]
      can :administer, :app
      can :manage, [Quiz,Section,Question,Option]
      can :read, [Category,Type,Topic,Package,QuizType,SectionType]
    elsif user.role? :publisher
      # Roles for publishers to create & publish a quiz.
      # http://www.tonyamoyal.com/2010/07/28/rails-authentication-with-devise-and-cancan-customizing-devise-controllers/
    elsif user.role? :student
      # Roles for Renaissance students.
      # Don't need to pay for buying Full-length tests.
    end
  end
end