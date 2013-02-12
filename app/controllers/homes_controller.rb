require 'digest/md5'
class HomesController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    split_user_full_name = current_user.full_name.split(' ',2)
    @first_name = split_user_full_name[0]
    @last_name = split_user_full_name[1]
    if current_user.profile_image_url.to_s ==''
      email_address = current_user.email.downcase
      hash = Digest::MD5.hexdigest(email_address)
      @profile_image_url = "http://www.gravatar.com/avatar/#{hash}"
    end
  end
  
  # TODO: Remove this before go-live.
  def reset_user_quizzes
    
    QuizUser.destroy_all(:user_id => current_user.id)
    
    redirect_to homes_index_path , notice: 'All quizzes are removed from the user account.'
    
  end
    
end
