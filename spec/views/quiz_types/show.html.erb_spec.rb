require 'spec_helper'

describe "quiz_types/show" do
  before(:each) do
    @quiz_type = assign(:quiz_type, stub_model(QuizType,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
