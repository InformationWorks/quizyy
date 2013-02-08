require 'spec_helper'

describe "offers/edit" do
  before(:each) do
    @offer = assign(:offer, stub_model(Offer,
      :code => "MyString",
      :title => "MyString",
      :desc => "MyText",
      :global => false,
      :active => false,
      :credits => 1
    ))
  end

  it "renders the edit offer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => offers_path(@offer), :method => "post" do
      assert_select "input#offer_code", :name => "offer[code]"
      assert_select "input#offer_title", :name => "offer[title]"
      assert_select "textarea#offer_desc", :name => "offer[desc]"
      assert_select "input#offer_global", :name => "offer[global]"
      assert_select "input#offer_active", :name => "offer[active]"
      assert_select "input#offer_credits", :name => "offer[credits]"
    end
  end
end
