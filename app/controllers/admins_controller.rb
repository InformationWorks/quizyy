class AdminsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :allow_only_admins!
  
  def home
    
    # Paid/Free In-Library Quizzes count.
    if current_user.role? :super_admin
      @full_paid_quizzes = Quiz.full.paid.approved
      @full_free_quizzes = Quiz.full.free.approved

      @category_paid_quizzes = Quiz.category.paid.approved
      @category_free_quizzes = Quiz.category.free.approved

      @topic_paid_quizzes = Quiz.topic.paid.approved
      @topic_free_quizzes = Quiz.topic.free.approved
    else
      redirect_to admins_quizzes_url()
    end
    
  end
  
  private
  
  def allow_only_admins!
    authorize! :administer, :app
  end
  
end
