class StoresController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  
  def timed_tests

    @package_1 = Package.find_by_position(1)
    @package_2 = Package.find_by_position(2)
    @package_3 = Package.find_by_position(3)
    
    @full_length_quizzes = Quiz.scoped_timed_full_quizzes(current_user).not_in_account_of_user(current_user).order('id ASC').first(3)
    @full_length_quizzes += current_user.quizzes.full.timed
    dictionary = Dictionary.all().shuffle()
    @full_length_quizzes.each do |quiz|
      quiz.word = dictionary.pop()
    end

    # Fetch categories & topics that have atleast one quiz.
    # TODO: .where("quizzes.approved = true")
    @categories = Category.with_timed_quiz_for_user(current_user).order('categories.name ASC').collect{|c| c.id}
    @categories = Category.timed_quizzes(current_user).where("categories.id IN (?)",@categories)
    @topics = Topic.with_timed_quiz_for_user(current_user).order('topics.name ASC').collect{|c| c.id}
    @topics = Topic.timed_quizzes(current_user).where("topics.id IN (?)",@topics)
    # Merge categories & topics in the same list.
    @categories_and_topics = []
    @categories_and_topics +=  @categories
    @categories_and_topics +=  @topics
    @categories_and_topics.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    @categories_and_topics.each do |category_and_topic|
      category_and_topic.quizzes.each do |quiz|
        quiz.word = dictionary.pop()
      end
    end


  end

  def practice_tests
   
    # Fetch categories & topics that have at-least one quiz.
    # TODO: .where("quizzes.approved = true")
    @categories = Category.with_practice_quiz_for_user(current_user).order('name ASC').collect{|c| c.id}
    @categories = Category.timed_quizzes(current_user).where("categories.id IN (?)",@categories)
    @topics = Topic.with_practice_quiz_for_user(current_user).order('name ASC').collect{|t| t.id}
    @topics = Topic.practice_quizzes(current_user).where("topics.id IN (?)",@topics)


    # Merge categories & topics in the same list.
    @categories_and_topics = []
    @categories_and_topics +=  @categories
    @categories_and_topics +=  @topics
    @categories_and_topics.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    dictionary = Dictionary.all().shuffle()
    @categories_and_topics.each do |category_and_topic|
      category_and_topic.quizzes.each do |quiz|
        quiz.word = dictionary.pop()
      end
    end
  end
  
  def show_timed_test
    @quiz = Quiz.find_by_slug!(params[:quiz_slug])
  end
  
  def show_practice_test
    @quiz = Quiz.find_by_slug!(params[:quiz_slug])
  end
  
  def category_timed_tests
    @category = Category.find_by_slug!(params[:category_slug])
    
    @quizzes = @category.scoped_timed_quizzes(current_user).order("id ASC")
  end
  
  def topic_timed_tests
    @topic = Topic.find_by_slug!(params[:topic_slug])
    
    @quizzes = @topic.scoped_timed_quizzes(current_user).order("id ASC")
  end
  
  def category_practice_tests
    @category = Category.find_by_slug!(params[:category_slug])
    
    @quizzes = @category.scoped_practice_quizzes(current_user).order("id ASC")
  end
  
  def topic_practice_tests
    @topic = Topic.find_by_slug!(params[:topic_slug])
    
    @quizzes = @topic.scoped_practice_quizzes(current_user).order("id ASC")
  end
  
  def full_practice_tests
    @quizzes = Quiz.scoped_practice_full_quizzes(current_user).not_in_account_of_user(current_user).order('id ASC')
    @quizzes += current_user.quizzes.full.timed
  end
  
  def full_timed_tests
    @quizzes = Quiz.scoped_timed_full_quizzes(current_user).not_in_account_of_user(current_user).order('id ASC')
    @quizzes += current_user.quizzes.full.timed
  end
  
end
