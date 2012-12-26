class HomesController < ApplicationController
  
  before_filter :authenticate_user!
  
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
    
    user = User.find(params[:id])
    
    logger.info("User params = " + params.to_s)
    
    user.profile_image = params[:Filedata]  
    
      if user.save
        return_text = '{"status":"true","imageurl":"' + user.profile_image_url + '" }';
      else
        return_text = "false"  
      end
      
      # Note: This was added because of wrong Content-Type returned.
      # Without this the respone on Javascript side was as below.
      # <pre style="word-wrap: break-word; white-space: pre-wrap;">true</pre>
      # Changed the Content-Type to get result as : true
      headers['Content-Type'] = 'text/html'
    
      render :inline => return_text
  end
  
end
