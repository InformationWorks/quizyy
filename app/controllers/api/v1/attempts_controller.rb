module Api
  module V1
    class AttemptsController < Api::V1::BaseController
      def index
        @attempt = Attempt.where(:user_id => current_user.id, :is_current =>true).first()
        respond_to do |format|
          format.json { render :json => @attempt }
        end
      end
      def update
        @attempt = Attempt.find(params[:id])
        if @attempt.update_attributes(params[:attempt])
          respond_with @attempt
        end
      end
    end
  end
end