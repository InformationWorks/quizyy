class Users::ProfilesController < ApplicationController
  
  before_filter :authenticate_user!
  
  # Action to update profile pic via AJAX.
  def update_profile_pic
    
    current_user.profile_image = params[:profile_pic_file]  
    
    if current_user.save
      return_text = '{"status":"true","imageurl":"' + current_user.profile_image_url + '" }';
    else
      return_text = '{"status":"false","errormsg":"unable to upload image at this time!" }';
    end
    
    # Note: This was added because of wrong Content-Type returned.
    # Without this the respone on Javascript side was as below.
    # <pre style="word-wrap: break-word; white-space: pre-wrap;">true</pre>
    # Changed the Content-Type to get result as : true
    headers['Content-Type'] = 'text/html'
  
    render :inline => return_text
    
  end
  
  # Action to remove profile pic via AJAX.
  def remove_profile_pic
    
    begin
      current_user.remove_profile_image = true
      current_user.save!
      return_text = '{"status":"true"}';
    rescue Exception => ex
      return_text = '{"status":"false","errormsg":"unable to remove image at this time!" }';
    end
    
    # Note: This was added because of wrong Content-Type returned.
    # Without this the respone on Javascript side was as below.
    # <pre style="word-wrap: break-word; white-space: pre-wrap;">true</pre>
    # Changed the Content-Type to get result as : true
    headers['Content-Type'] = 'text/html'
  
    render :inline => return_text
    
  end
  
  
end