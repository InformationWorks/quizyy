class StoresController < ApplicationController
  def full_quizzes
  end

  def category_quizzes
   
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
end
