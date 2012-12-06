require 'spec_helper'

describe "section_types/index" do
  before(:each) do
    assign(:section_types, [
      stub_model(SectionType,
        :name => "Name",
        :instruction => "MyText"
      ),
      stub_model(SectionType,
        :name => "Name",
        :instruction => "MyText"
      )
    ])
  end

  it "renders a list of section_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
