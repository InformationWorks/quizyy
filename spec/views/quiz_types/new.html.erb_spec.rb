require 'spec_helper'

describe "quiz_types/new" do
  before(:each) do
    assign(:quiz_type, stub_model(QuizType,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new quiz_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => quiz_types_path, :method => "post" do
      assert_select "input#quiz_type_name", :name => "quiz_type[name]"
    end
  end
end
