class StoresController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :initialize_cart
  
  # match "timed_tests" => "stores#timed_tests", via: [:get], :as => "timed_tests"
  def timed_tests

    # Get packages.
    @package_1 = Package.find_by_position(1)
    @package_2 = Package.find_by_position(2)
    @package_3 = Package.find_by_position(3)
    
    # Get full-length quizzes.
    @full_length_quizzes = Quiz.scoped_for_user(current_user).full.timed.not_in_account_of_user(current_user).order('id ASC').first(3)
    @purchased_full_length_timed_quizzes = current_user.quizzes.full.timed
    @full_length_quizzes += @purchased_full_length_timed_quizzes
    load_words_for_quizzes(@full_length_quizzes)
    
    # generate store entities for timed.
    @store_entities = generate_store_entities(true)
    
    # Load words for each quiz.
    @store_entities.each do |entity_name_quizzes|
      load_words_for_quizzes(entity_name_quizzes[:quizzes])
    end
    
  end

  # match "practice_tests" => "stores#practice_tests", via: [:get], :as => "practice_tests"
  def practice_tests
   
    # generate store entities for practice.
    @store_entities = generate_store_entities(false)
    
    # Load words for each quiz.
    @store_entities.each do |entity_name_quizzes|
      load_words_for_quizzes(entity_name_quizzes[:quizzes])
    end
    
  end
  
  # match "timed_tests/full_tests" => "stores#show_all_full_timed_tests", via: [:get], :as => "show_all_full_timed_tests"
  def show_all_full_timed_tests
    @quizzes = Quiz.scoped_for_user(current_user).full.timed.not_in_account_of_user(current_user).order('id ASC')
    @quizzes += current_user.quizzes.full.timed
    @quizzes = load_words_for_quizzes(@quizzes)
    
    @name = "Full length tests"
    render "show_all_tests"
  end
  
  # match "timed_tests/full_tests/:quiz_slug" => "stores#show_full_timed_test", via: [:get], :as => "show_full_timed_test"
  def show_full_timed_test
    
    @quiz = Quiz.scoped_for_user(current_user).find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil || @quiz.timed != true || @quiz.quiz_type_id != QuizType.find_by_name("FullQuiz").id)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end
  end
  
  # match "timed_tests/categories/:category_slug/:quiz_slug" => "stores#show_category_timed_test", via: [:get], :as => "show_category_timed_test"
  def show_category_timed_test
    
    @quiz = Quiz.scoped_for_user(current_user).find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil || @quiz.timed != true || @quiz.quiz_type_id != QuizType.find_by_name("CategoryQuiz").id)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end
  end
  
  # match "timed_tests/topics/:topic_slug/:quiz_slug" => "stores#show_topic_timed_test", via: [:get], :as => "show_topic_timed_test"
  def show_topic_timed_test
    
    @quiz = Quiz.scoped_for_user(current_user).find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil || @quiz.timed != true || @quiz.quiz_type_id != QuizType.find_by_name("TopicQuiz").id)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end  
  end
  
  # match "practice_tests/categories/:category_slug/:quiz_slug" => "stores#show_category_practice_test", via: [:get], :as => "show_category_practice_test"
  def show_category_practice_test
    
    @quiz = Quiz.scoped_for_user(current_user).find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil || @quiz.timed || @quiz.quiz_type_id != QuizType.find_by_name("CategoryQuiz").id)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end
  end
  
  # match "practice_tests/topics/:topic_slug/:quiz_slug" => "stores#show_topic_practice_tests", via: [:get], :as => "show_topic_practice_tests"
  def show_topic_practice_test
    
    @quiz = Quiz.scoped_for_user(current_user).find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil || @quiz.timed || @quiz.quiz_type_id != QuizType.find_by_name("TopicQuiz").id)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end
  end
  
  # match "timed_tests/categories/:category_slug" => "stores#category_all_timed_tests", via: [:get], :as => "category_all_timed_tests"
  def category_all_timed_tests
    @category = Category.find_by_slug!(params[:category_slug])
    
    if @category
      @quizzes = Quiz.scoped_for_user(current_user).not_in_account_of_user(current_user).category.specific_category(@category).timed.order('id ASC')
      @quizzes += current_user.quizzes.category.specific_category(@category).timed
      @quizzes = load_words_for_quizzes(@quizzes)
      @name = @category.name
    else
      @quizzes = []
    end
    
    render "show_all_tests"
    
  end
  
  # match "timed_tests/topics/:topic_slug" => "stores#topic_all_timed_tests", via: [:get], :as => "topic_all_timed_tests"
  def topic_all_timed_tests
    @topic = Topic.find_by_slug!(params[:topic_slug])
    
    if @topic
      @quizzes = Quiz.scoped_for_user(current_user).not_in_account_of_user(current_user).topic.specific_topic(@topic).timed.order('id ASC')
      @quizzes += current_user.quizzes.topic.specific_topic(@topic).timed
      @quizzes = load_words_for_quizzes(@quizzes)
      @name = @topic.name
    else
      @quizzes = []
    end
    
    render "show_all_tests"
  end
  
  # match "practice_tests/categories/:category_slug" => "stores#category_all_practice_tests", via: [:get], :as => "category_all_practice_tests"
  def category_all_practice_tests
    @category = Category.find_by_slug!(params[:category_slug])

    if @category
      @quizzes = Quiz.scoped_for_user(current_user).not_in_account_of_user(current_user).category.specific_category(@category).practice.order('id ASC')
      @quizzes += current_user.quizzes.category.specific_category(@category).practice
      @quizzes = load_words_for_quizzes(@quizzes)      
      @name = @category.name
    else
      @quizzes = []
    end
    
    render "show_all_tests"
  end
  
  # match "practice_tests/topics/:topic_slug" => "stores#topic_all_practice_tests", via: [:get], :as => "topic_all_practice_tests"
  def topic_all_practice_tests
    @topic = Topic.find_by_slug!(params[:topic_slug])
    
    if @topic
      @quizzes = Quiz.scoped_for_user(current_user).not_in_account_of_user(current_user).topic.specific_topic(@topic).practice.order('id ASC')
      @quizzes += current_user.quizzes.topic.specific_topic(@topic).practice
      @quizzes = load_words_for_quizzes(@quizzes)
      @name = @topic.name
    else
      @quizzes = []
    end
    
    render "show_all_tests"
  end

  private
  
  # Generate store entities
  def generate_store_entities(timed)
    
    # Get array of category & topic structures.
    # [ { entity => string, name => string, slug => string , quizzes => array_of_quizzes } ]
    store_category_entities = Quiz.store_entity_name_quizzes("Category",timed,current_user)
    store_topic_entities = Quiz.store_entity_name_quizzes("Topic",timed,current_user)
    
    # Combile category & topic array and sort them by name.
    store_entities = []
    store_entities += store_category_entities
    store_entities += store_topic_entities
    store_entities.sort! { |a,b| a[:name].downcase <=> b[:name].downcase }
    
    return store_entities
    
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
