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
        if @attempt.update_attributes(params[:attempt].except(:current_time))
          respond_with @attempt
        end
      end
      def update_time
        @attempt = Attempt.find(params[:attempt_id])
        @current_time = params[:current_time]
        @attempt.current_time = @current_time if @attempt
        @attempt.save()
        Visit.update(@attempt.id,@attempt.current_question_id,@current_time)
        respond_to do |format| 
          format.json {render :json => @attempt }
        end
      end
    end
  end
end