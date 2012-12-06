require "spec_helper"

describe QuizTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/quiz_types").should route_to("quiz_types#index")
    end

    it "routes to #new" do
      get("/quiz_types/new").should route_to("quiz_types#new")
    end

    it "routes to #show" do
      get("/quiz_types/1").should route_to("quiz_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/quiz_types/1/edit").should route_to("quiz_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/quiz_types").should route_to("quiz_types#create")
    end

    it "routes to #update" do
      put("/quiz_types/1").should route_to("quiz_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/quiz_types/1").should route_to("quiz_types#destroy", :id => "1")
    end

  end
end
