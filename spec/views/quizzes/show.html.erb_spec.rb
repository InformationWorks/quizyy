require 'spec_helper'

describe "quizzes/show" do
  before(:each) do
    @quiz = assign(:quiz, stub_model(Quiz,
      :name => "Name",
      :random => false,
      :quiz_type => nil,
      :category => nil,
      :topic => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/false/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
  end
end
