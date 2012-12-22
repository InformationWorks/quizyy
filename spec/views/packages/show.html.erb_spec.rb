require 'spec_helper'

describe "packages/show" do
  before(:each) do
    @package = assign(:package, stub_model(Package,
      :name => "Name",
      :desc => "MyText",
      :price => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
    rendered.should match(/9.99/)
  end
end
