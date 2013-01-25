class StoresController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  
  def timed_tests
    
    @package_1 = Package.find_by_position(1)
    @package_2 = Package.find_by_position(2)
    @package_3 = Package.find_by_position(3)
    
    @full_length_quizzes = Quiz.scoped_timed_full_quizzes(current_user).not_in_account_of_user(current_user).order('id ASC').first(3)
    @full_length_quizzes += current_user.quizzes.full.timed
    
    # Fetch categories & topics that have atleast one quiz.
    # TODO: .where("quizzes.approved = true")
    @categories = Category.with_timed_quiz_for_user(current_user).order('name ASC')
    @topics = Topic.with_timed_quiz_for_user(current_user).order('name ASC')
    
    # Merge categories & topics in the same list.
    @categories_and_topics = []
    @categories_and_topics +=  @categories
    @categories_and_topics +=  @topics
    @categories_and_topics.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end

  def practice_tests
   
    # Fetch categories & topics that have at-least one quiz.
    # TODO: .where("quizzes.approved = true")
    @categories = Category.with_practice_quiz_for_user(current_user).order('name ASC')
    @topics = Topic.with_practice_quiz_for_user(current_user).order('name ASC')
    
    # Merge categories & topics in the same list.
    @categories_and_topics = []
    @categories_and_topics +=  @categories
    @categories_and_topics +=  @topics
    @categories_and_topics.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end
  
  def show_timed_test
    @quiz = Quiz.find_by_slug!(params[:quiz_slug])
  end
  
  def show_practice_test
    @quiz = Quiz.find_by_slug!(params[:quiz_slug])
  end
  
end
