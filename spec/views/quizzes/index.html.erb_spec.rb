require 'spec_helper'

describe "quizzes/index" do
  before(:each) do
    assign(:quizzes, [
      stub_model(Quiz,
        :name => "Name",
        :random => false,
        :quiz_type => nil,
        :category => nil,
        :topic => nil
      ),
      stub_model(Quiz,
        :name => "Name",
        :random => false,
        :quiz_type => nil,
        :category => nil,
        :topic => nil
      )
    ])
  end

  it "renders a list of quizzes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
