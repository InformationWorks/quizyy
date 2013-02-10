class HomesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    split_user_full_name = current_user.full_name.split(' ',2)
    @first_name = split_user_full_name[0]
    @last_name = split_user_full_name[1]
    # if params[:category] is true activate category
    if params[:practice_quiz] == "true"
      @active_tab = :practice_quiz
    else
      @active_tab = :timed_quiz
    end 
    
  end
  
  # TODO: Remove this before go-live.
  def reset_user_quizzes
    
    QuizUser.destroy_all(:user_id => current_user.id)
    
    redirect_to homes_index_path , notice: 'All quizzes are removed from the user account.'
    
  end
    
end
