require 'spec_helper'

describe "quizzes/edit" do
  before(:each) do
    @quiz = assign(:quiz, stub_model(Quiz,
      :name => "MyString",
      :random => false,
      :quiz_type => nil,
      :category => nil,
      :topic => nil
    ))
  end

  it "renders the edit quiz form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => quizzes_path(@quiz), :method => "post" do
      assert_select "input#quiz_name", :name => "quiz[name]"
      assert_select "input#quiz_random", :name => "quiz[random]"
      assert_select "input#quiz_quiz_type", :name => "quiz[quiz_type]"
      assert_select "input#quiz_category", :name => "quiz[category]"
      assert_select "input#quiz_topic", :name => "quiz[topic]"
    end
  end
end
