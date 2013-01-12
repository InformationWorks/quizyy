class CreditsController < ApplicationController
  def index
    @users = User.all
  end
  def new
    @user = User.find(params[:user_id])
  end
  def create
    
    @user = User.find(params[:user_id])
    @user.credits += params[:credits_to_add].to_i
    @user.save!
    
    redirect_to new_credit_path(@user.id), notice: "Credit added successfully."
    
  end
end
