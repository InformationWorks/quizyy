module Api
  module V1
    class VisitsController < Api::V1::BaseController
      def create
        attempt_id = params[:attempt_id]
        question_id = params[:question_id]
        begin
          visit = Visit.create(:attempt_id => attempt_id,:question_id=>question_id)
          respond_to do |format|
            format.json { render :json => @visit }
          end
        rescue => e
          respond_to do |format|
            format.json { render :json => {:success => false, :message => e.message} }
          end
        end
      end
      def update
        attempt_id = params[:attempt_id]
        question_id = params[:question_id]
        time_spent = params[:time_spent]
        begin
          visit = Visit.where(:attempt_id => attempt_id,:question_id=>question_id).last
          visit.time_spent = time_spent if visit
          visit.save
          respond_to do |format|
            format.json { render :json => @visit }
          end
        rescue => e
          respond_to do |format|
            format.json { render :json => {:success => false, :message => e.message} }
          end
        end
      end
    end
  end
end