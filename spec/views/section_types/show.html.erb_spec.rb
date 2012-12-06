require 'spec_helper'

describe "section_types/show" do
  before(:each) do
    @section_type = assign(:section_type, stub_model(SectionType,
      :name => "Name",
      :instruction => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/MyText/)
  end
end
