require 'spec_helper'

describe "quiz_types/edit" do
  before(:each) do
    @quiz_type = assign(:quiz_type, stub_model(QuizType,
      :name => "MyString"
    ))
  end

  it "renders the edit quiz_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => quiz_types_path(@quiz_type), :method => "post" do
      assert_select "input#quiz_type_name", :name => "quiz_type[name]"
    end
  end
end
