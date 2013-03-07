class StoresController < ApplicationController
  
  before_filter :initialize_cart
  
  # match 'store' => "stores#index", via: [:get], :as => "store"
  def index
    
    # generate store entities.
    @store_entities = generate_store_entities
    
    # Load words for each quiz.
    @store_entities.each do |entity_name_quizzes|
      load_words_for_quizzes(entity_name_quizzes[:quizzes])
    end
    
  end
  
  # match "store/full_tests" => "stores#show_all_full_tests", via: [:get], :as => "show_all_full_tests"
  def show_all_full_tests
    @quizzes = Quiz.scoped_for_user(current_user).full.not_in_account_of_user(current_user).order('id ASC')
    @quizzes += current_user.quizzes.full
    @quizzes = load_words_for_quizzes(@quizzes)
    
    @name = "Full length tests"
    render "show_all_tests"
  end
  
  # match "store/verbal_tests" => "stores#show_all_verbal_tests", via: [:get], :as => "show_all_verbal_tests"
  def show_all_verbal_tests
    @quizzes = Quiz.store_verbal_section_quizzes(current_user)
    @quizzes = load_words_for_quizzes(@quizzes)
    
    @name = "Verbal tests"
    render "show_all_tests"
  end
  
  # match "store/quant_tests" => "stores#show_all_quant_tests", via: [:get], :as => "show_all_quant_tests"
  def show_all_quant_tests
    @quizzes = Quiz.store_quant_section_quizzes(current_user)
    @quizzes = load_words_for_quizzes(@quizzes)
    
    @name = "Quant tests"
    render "show_all_tests"
  end
  
  # match "store/categories/:category_slug" => "stores#show_category_all_tests", via: [:get], :as => "show_category_all_tests"
  def show_category_all_tests
    @category = Category.find_by_slug!(params[:category_slug])
    
    if @category
      @quizzes = Quiz.store_category_quizzes(current_user,@category)
      @quizzes = load_words_for_quizzes(@quizzes)
      @name = @category.name
    else
      @quizzes = []
    end
    
    render "show_all_tests"
    
  end
  
  # match "store/topics/:topic_slug" => "stores#show_topic_all_tests", via: [:get], :as => "show_topic_all_tests"
  def show_topic_all_tests
    @topic = Topic.find_by_slug!(params[:topic_slug])
    
    if @topic
      @quizzes = Quiz.store_topic_quizzes(current_user,@topic)
      @quizzes = load_words_for_quizzes(@quizzes)
      @name = @topic.name
    else
      @quizzes = []
    end
    
    render "show_all_tests"
  end
  
  # match "store/full_tests/:quiz_slug" => "stores#show_full_test", via: [:get], :as => "show_full_test"
  def show_full_test
    
    @quiz = Quiz.scoped_for_user(current_user).find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil || @quiz.quiz_type_id != QuizType.find_by_name("FullQuiz").id)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end
  end
  
  # match "store/verbal_tests/:quiz_slug" => "stores#show_verbal_test", via: [:get], :as => "show_verbal_test"
  def show_verbal_test
    
    @quiz = Quiz.scoped_for_user(current_user).section.verbal.find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end
  end
  
  # match "store/quant_tests/:quiz_slug" => "stores#show_quant_test", via: [:get], :as => "show_quant_test"
  def show_quant_test
    
    @quiz = Quiz.scoped_for_user(current_user).section.quant.find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end
  end
  
  # match "store/categories/:category_slug/:quiz_slug" => "stores#show_category_test", via: [:get], :as => "show_category_test"
  def show_category_test
    
    @quiz = Quiz.scoped_for_user(current_user).find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil || @quiz.quiz_type_id != QuizType.find_by_name("CategoryQuiz").id)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end
  end
  
  # match "store/topics/:topic_slug/:quiz_slug" => "stores#show_topic_test", via: [:get], :as => "show_topic_test"
  def show_topic_test
    
    @quiz = Quiz.scoped_for_user(current_user).find_by_slug(params[:quiz_slug])
    
    if (@quiz == nil || @quiz.quiz_type_id != QuizType.find_by_name("TopicQuiz").id)
      redirect_to "/404.html"
    else
      render 'show_test_detail'
    end  
  end
  
  # Process cart and redirect to available test.
  def proceed_to_checkout
    
    order = Order.new
    order.cart_id = @cart.id
    order.responseCode = 100
    order.responseDescription = "Tests added to your account."
    order.save!
    
    cart = Cart.find(order.cart_id)
        
    # Add each cartitem to user's account.
    cart.cart_items.each do | cart_item |
      if cart_item.quiz_id != nil
      # Add Quiz
        quiz_user = QuizUser.new
        quiz_user.quiz_id = cart_item.quiz_id
        quiz_user.user_id = current_user.id
        quiz_user.save!
      end
    end
    
    redirect_to homes_index_path, notice: "Test added to your account."
  end
  
  # Add a test and take to available test.
  def add_test_to_account
    
    quiz_user = QuizUser.new
    quiz_user.quiz_id = params[:quiz_id]
    quiz_user.user_id = current_user.id
    quiz_user.save!
    
    redirect_to homes_index_path, notice: "Test added to your account."
    
  end

  private
  
  # Generate store entities
  def generate_store_entities
    
    # Get array of category & topic structures.
    # [ { entity => string, name => string, slug => string , quizzes => array_of_quizzes } ]
    store_category_entities = Quiz.store_entity_name_quizzes("Category",current_user)
    #store_topic_entities = Quiz.store_entity_name_quizzes("Topic",current_user)
    
    # Combile category & topic array and sort them by name.
    store_entities = []
    store_entities += store_category_entities
    #store_entities += store_topic_entities
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
