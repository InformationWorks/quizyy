require 'spec_helper'

describe "quiz_types/index" do
  before(:each) do
    assign(:quiz_types, [
      stub_model(QuizType,
        :name => "Name"
      ),
      stub_model(QuizType,
        :name => "Name"
      )
    ])
  end

  it "renders a list of quiz_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
