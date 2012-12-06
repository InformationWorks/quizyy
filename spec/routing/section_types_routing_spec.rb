require "spec_helper"

describe SectionTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/section_types").should route_to("section_types#index")
    end

    it "routes to #new" do
      get("/section_types/new").should route_to("section_types#new")
    end

    it "routes to #show" do
      get("/section_types/1").should route_to("section_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/section_types/1/edit").should route_to("section_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/section_types").should route_to("section_types#create")
    end

    it "routes to #update" do
      put("/section_types/1").should route_to("section_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/section_types/1").should route_to("section_types#destroy", :id => "1")
    end

  end
end
