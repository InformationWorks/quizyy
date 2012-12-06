require 'spec_helper'

describe "section_types/edit" do
  before(:each) do
    @section_type = assign(:section_type, stub_model(SectionType,
      :name => "MyString",
      :instruction => "MyText"
    ))
  end

  it "renders the edit section_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => section_types_path(@section_type), :method => "post" do
      assert_select "input#section_type_name", :name => "section_type[name]"
      assert_select "textarea#section_type_instruction", :name => "section_type[instruction]"
    end
  end
end
