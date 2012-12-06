require "spec_helper"

describe QuizzesController do
  describe "routing" do

    it "routes to #index" do
      get("/quizzes").should route_to("quizzes#index")
    end

    it "routes to #new" do
      get("/quizzes/new").should route_to("quizzes#new")
    end

    it "routes to #show" do
      get("/quizzes/1").should route_to("quizzes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/quizzes/1/edit").should route_to("quizzes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/quizzes").should route_to("quizzes#create")
    end

    it "routes to #update" do
      put("/quizzes/1").should route_to("quizzes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/quizzes/1").should route_to("quizzes#destroy", :id => "1")
    end

  end
end
