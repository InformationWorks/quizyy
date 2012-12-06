require 'spec_helper'

describe "sections/edit" do
  before(:each) do
    @section = assign(:section, stub_model(Section,
      :name => "MyString",
      :sequence_no => 1,
      :quiz => nil,
      :section_type => nil
    ))
  end

  it "renders the edit section form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sections_path(@section), :method => "post" do
      assert_select "input#section_name", :name => "section[name]"
      assert_select "input#section_sequence_no", :name => "section[sequence_no]"
      assert_select "input#section_quiz", :name => "section[quiz]"
      assert_select "input#section_section_type", :name => "section[section_type]"
    end
  end
end
