module Api
  module V1
    class QuizzesController < Api::V1::BaseController
      def show
        
        @quiz = Quiz.find(params[:id])
        
      end
    end
  end
end