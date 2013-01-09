module Api
  module V1
    class AttemptDetailsController < Api::V1::BaseController
      def create
        question_id = params[:attempt_details][:question_id]
        options = params[:attempt_details][:options]
        if options.nil?
          user_input = params[:attempt_details][:user_input]
        end
        begin
          AttemptDetail.destroy_all(:attempt_id => current_attempt.id,:question_id => question_id)
          unless options.nil?
            options.each do |option|
              AttemptDetail.create(:attempt_id=>current_attempt.id,:question_id=>question_id,:option_id=>option[1][:value])
            end
          else
            combined_input = []
            user_input.each do |input|
              combined_input << input[1][:value]
            end
            AttemptDetail.create(:attempt_id=>current_attempt.id,:question_id=>question_id,:user_input=>combined_input.join(','))
          end
          respond_to do |format|
            format.json { render :json => {:success=>true} }
          end
        rescue => e
          respond_to do |format|
            format.json { render :json => {:success=>false, :message => e.message} }
          end
        end
      end
    end
  end
end