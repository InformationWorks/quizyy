require 'spec_helper'

describe "quizzes/new" do
  before(:each) do
    assign(:quiz, stub_model(Quiz,
      :name => "MyString",
      :random => false,
      :quiz_type => nil,
      :category => nil,
      :topic => nil
    ).as_new_record)
  end

  it "renders new quiz form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => quizzes_path, :method => "post" do
      assert_select "input#quiz_name", :name => "quiz[name]"
      assert_select "input#quiz_random", :name => "quiz[random]"
      assert_select "input#quiz_quiz_type", :name => "quiz[quiz_type]"
      assert_select "input#quiz_category", :name => "quiz[category]"
      assert_select "input#quiz_topic", :name => "quiz[topic]"
    end
  end
end
