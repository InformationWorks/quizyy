require 'spec_helper'

describe "sections/new" do
  before(:each) do
    assign(:section, stub_model(Section,
      :name => "MyString",
      :sequence_no => 1,
      :quiz => nil,
      :section_type => nil
    ).as_new_record)
  end

  it "renders new section form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sections_path, :method => "post" do
      assert_select "input#section_name", :name => "section[name]"
      assert_select "input#section_sequence_no", :name => "section[sequence_no]"
      assert_select "input#section_quiz", :name => "section[quiz]"
      assert_select "input#section_section_type", :name => "section[section_type]"
    end
  end
end
