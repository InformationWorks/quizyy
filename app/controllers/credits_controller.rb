class CreditsController < ApplicationController
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.find(params[:user_id])
  end
  
  def create
    
    # Add credit to the user account.
    @user = User.find(params[:user_id])
    @user.credits += params[:credits_to_add].to_i
    @user.save!
    
    # Log the "AddCredit" activity in ActivityLog.
    activity_log = ActivityLog.new
    activity_log.actor_id = current_user.id
    activity_log.action = "AddCredit"
    activity_log.target_id = @user.id
    activity_log.activity = "added #{params[:credits_to_add]} to #{@user.full_name}'s account."
    activity_log.save!
    
    redirect_to new_credit_path(@user.id), notice: "Credit added successfully."
    
  end
  
  def activity_log
    @activity_logs = ActivityLog.order("updated_at desc").all
  end
  
end
