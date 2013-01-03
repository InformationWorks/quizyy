class StoresController < ApplicationController
  
  before_filter :authenticate_user!
  
  def timed_tests
    
    @package_1 = Package.find_by_position(1)
    @package_2 = Package.find_by_position(2)
    @package_3 = Package.find_by_position(3)
    
    @full_length_quizzes = Quiz.where(['quiz_type_id = ? AND timed = true AND id not in (?) ',QuizType.find_by_name("FullQuiz").id,current_user.quizzes.pluck('quizzes.id')]).order('id ASC').first(3)
    @full_length_quizzes += current_user.quizzes.where(['quiz_type_id = ? AND timed = true',QuizType.find_by_name("FullQuiz").id])
    
    # Fetch categories & topics that have atleast one quiz.
    # TODO: .where("quizzes.approved = true")
    @categories = Category.joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true').order('id ASC')
    @topics = Topic.joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0").where('quizzes.timed = true').order('id ASC')
    
    # Merge categories & topics in the same list.
    # TODO: Implement sorting
    @categories_and_topics = []
    @categories_and_topics +=  @categories
    @categories_and_topics +=  @topics
  end

  def practice_tests
   
    # Fetch categories & topics that have atleast one quiz.
    # TODO: .where("quizzes.approved = true")
    @categories = Category.joins(:quizzes).group("categories.id HAVING count(quizzes.id) > 0")
    @topics = Topic.joins(:quizzes).group("topics.id HAVING count(quizzes.id) > 0")
    
    # Merge categories & topics in the same list.
    # TODO: Implement sorting
    @categories_and_topics = []
    @categories_and_topics +=  @categories
    @categories_and_topics +=  @topics
    
  end
  
  # Once the user has purchased a package add the quizzes from the 
  # package to the users available quizzes.
  def add_package_to_user
    
    begin
    
      package_quizzes_ids = Package.find(params[:package_id]).quizzes.pluck(:quiz_id)
    
      package_quizzes_ids.each do |quiz_id|
      
        quiz_user = QuizUser.new
        quiz_user.quiz_id = quiz_id
        quiz_user.user_id = current_user.id
        quiz_user.save!
      
      end
      
      redirect_to homes_index_path, notice: "#{package_quizzes_ids.count} quizzes added to your account."
      
    rescue Exception => ex
      
      logger.info("Error adding package to account : " + ex.message)
      redirect_to :action => full_quizzes, notice: 'Error adding package to your account.'
    
    end
    
  end
  
  # Once the user has purchased a quiz add the quiz to the 
  # users available quizzes.
  def add_quiz_to_user
    
    begin
      
      quiz_user = QuizUser.new
      quiz_user.quiz_id = params[:quiz_id]
      quiz_user.user_id = current_user.id
      quiz_user.save!
      
      flash[:notice] = "New quiz added to your account."
      redirect_to :controller => :homes , :action => :index, :category_quiz => true
      
    rescue Exception => ex
      
      logger.info("Error adding package to account : " + ex.message)
      redirect_to :action => full_quizzes, notice: 'Error adding quiz to your account.'
    
    end
    
  end
  
end
