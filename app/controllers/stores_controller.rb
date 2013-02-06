class StoresController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  
  def timed_tests

    # Get packages.
    @package_1 = Package.find_by_position(1)
    @package_2 = Package.find_by_position(2)
    @package_3 = Package.find_by_position(3)
    
    # Get full-length quizzes.
    @full_length_quizzes = Quiz.scoped_timed_full_quizzes(current_user).not_in_account_of_user(current_user).order('id ASC').first(3)
    @full_length_quizzes += current_user.quizzes.full.timed
    load_words_for_quizzes(@full_length_quizzes)
    
    # generate store entities for timed.
    generate_store_entities(true)
    
    # Load words for each quiz.
    @store_entities.each do |entity_name_quizzes|
      load_words_for_quizzes(entity_name_quizzes[:quizzes])
    end
    
  end

  def practice_tests
   
    # generate store entities for practice.
    generate_store_entities(false)
    
    # Load words for each quiz.
    @store_entities.each do |entity_name_quizzes|
      load_words_for_quizzes(entity_name_quizzes[:quizzes])
    end
    
    # Load words for each quiz.
    @store_entities.each do |entity_name_quizzes|
      load_words_for_quizzes(entity_name_quizzes[:quizzes])
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
    @category = Category.timed_quizzes(current_user,@category.id).order("quizzes.id ASC").first()
    if @category
      @quizzes = load_words_for_quizzes(@category.quizzes)
    else
      @quizzes = []
    end
  end
  
  def topic_timed_tests
    @topic = Topic.find_by_slug!(params[:topic_slug])
    @topic = Topic.timed_quizzes(current_user,@topic.id).order("quizzes.id ASC").first()
    if @topic
      @quizzes = load_words_for_quizzes(@topic.quizzes)
    else
      @quizzes = []
    end
  end
  
  def category_practice_tests
    @category = Category.find_by_slug!(params[:category_slug])
    @category = Category.practice_quizzes(current_user,@category.id).order("quizzes.id ASC").first()
    if @category
      @quizzes = load_words_for_quizzes(@category.quizzes)
    else
      @quizzes = []
    end
  end
  
  def topic_practice_tests
    @topic = Topic.find_by_slug!(params[:topic_slug])
    @topic = Topic.practice_quizzes(current_user,@topic.id).order("quizzes.id ASC").first()
    if @topic
      @quizzes = load_words_for_quizzes(@topic.quizzes)
    else
      @quizzes = []
    end
  end
  
  def full_practice_tests
    @quizzes = Quiz.scoped_practice_full_quizzes(current_user).not_in_account_of_user(current_user).order('id ASC')
    @quizzes += current_user.quizzes.full.timed
    @quizzes = load_words_for_quizzes(@quizzes)
  end
  
  def full_timed_tests
    @quizzes = Quiz.scoped_timed_full_quizzes(current_user).not_in_account_of_user(current_user).order('id ASC')
    @quizzes += current_user.quizzes.full.timed
    @quizzes = load_words_for_quizzes(@quizzes)
  end

  private
  
  # Generate store entities
  def generate_store_entities(timed)
    
    # Get array of category & topic structures.
    # [ { entity => string, name => string, slug => string , quizzes => array_of_quizzes } ]
    @store_category_entities = Quiz.store_entity_name_quizzes("Category",timed,current_user)
    @store_topic_entities = Quiz.store_entity_name_quizzes("Topic",timed,current_user)
    
    # Combile category & topic array and sort them by name.
    @store_entities = []
    @store_entities += @store_category_entities
    @store_entities += @store_topic_entities
    @store_entities.sort! { |a,b| a[:name].downcase <=> b[:name].downcase }
    
    return @store_entities
    
  end
  
  # load words for each quiz.
  def load_words_for_quizzes(quizzes)
    dictionary = Dictionary.all().shuffle()
    if quizzes
      quizzes.each do |quiz|
        quiz.word = dictionary.pop()
      end
      quizzes
    else
      []
    end
  end
end
