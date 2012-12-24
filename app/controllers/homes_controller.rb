class HomesController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:index]
  
  def index
    split_user_full_name = current_user.full_name.split(' ',2)
    @first_name = split_user_full_name[0]
    @last_name = split_user_full_name[1]
    
    # if params[:category] is true activate category
    if params[:category_quiz] == "true"
      @active_tab = :category_quiz
    else
      @active_tab = :full_quiz
    end 
    
  end
  
  # TODO: Remove this before go-live.
  def reset_user_quizzes
    
    QuizUser.destroy_all(:user_id => current_user.id)
    
    redirect_to homes_index_path , notice: 'All quizzes are removed from the user account.'
    
  end
  
  # TODO: Remove this before go-live.
  def change_profile_pic
        
  end
  
  # TODO: Remove this before go-live.
  def update_profile_pic
    respond_to do |format|
      if current_user.update_attributes(params[:user])
        format.html { redirect_to :action => :index, :notice => 'Photo uploaded successfully.' }
        format.json { head :no_content }
      else
        format.html { render action: "index" }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
