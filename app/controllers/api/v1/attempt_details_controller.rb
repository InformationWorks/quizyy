module Api
  module V1
    class AttemptDetailsController < Api::V1::BaseController
      def create
        question_id = params[:attempt_details][:question_id]
        options = params[:attempt_details][:options]
        #if options are not sent means the question is TC or SIP in which user provide input
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
            input_str = nil
            #a hash is sent for text completion type question and a string for select in passage
            if user_input.is_a?(Hash)
              user_input.each do |input|
                combined_input << input[1][:value]
              end
              input_str=combined_input.join(',')
            elsif user_input.is_a?(String)
              input_str = user_input
            end

            AttemptDetail.create(:attempt_id=>current_attempt.id,:question_id=>question_id,:user_input=>input_str)
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