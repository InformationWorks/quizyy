module Api
  module V1
    class Api::V1::BaseController < ActionController::Base
     respond_to :json,:xml
    end
  end
end