module Api
  module V1
    class VisitsController < Api::V1::BaseController
      def create
        attempt_id = params[:attempt_id]
        question_id = params[:question_id]
        time = params[:time]
        begin
          visit = Visit.create(:attempt_id => attempt_id,:question_id=>question_id,:start => time)
          respond_to do |format|
            format.json { render :json => visit }
          end
        rescue => e
          respond_to do |format|
            format.json { render :json => {:success => false, :message => e.message} }
          end
        end
      end
      def set_end_time
        attempt_id = params[:attempt_id]
        question_id = params[:question_id]
        time = params[:time]
        visit = Visit.update(attempt_id,question_id,time)
        respond_to do |format|
            format.json { render :json => visit }
        end 
      end
    end
  end
end
