require "spec_helper"

describe OffersController do
  describe "routing" do

    it "routes to #index" do
      get("/offers").should route_to("offers#index")
    end

    it "routes to #new" do
      get("/offers/new").should route_to("offers#new")
    end

    it "routes to #show" do
      get("/offers/1").should route_to("offers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/offers/1/edit").should route_to("offers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/offers").should route_to("offers#create")
    end

    it "routes to #update" do
      put("/offers/1").should route_to("offers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/offers/1").should route_to("offers#destroy", :id => "1")
    end

  end
end
