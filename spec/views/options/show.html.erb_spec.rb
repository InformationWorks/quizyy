require 'spec_helper'

describe "options/show" do
  before(:each) do
    @option = assign(:option, stub_model(Option,
      :content => "MyText",
      :correct => false,
      :question => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/false/)
    rendered.should match(//)
  end
end
