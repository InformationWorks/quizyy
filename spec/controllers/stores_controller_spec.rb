require 'spec_helper'

describe StoresController do

  describe "GET 'full_quizzes'" do
    it "returns http success" do
      get 'full_quizzes'
      response.should be_success
    end
  end

  describe "GET 'category_quizzes'" do
    it "returns http success" do
      get 'category_quizzes'
      response.should be_success
    end
  end

end
