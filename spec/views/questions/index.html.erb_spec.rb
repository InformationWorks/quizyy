require 'spec_helper'

describe "questions/index" do
  before(:each) do
    assign(:questions, [
      stub_model(Question,
        :sequence_no => 1,
        :header => "MyText",
        :instruction => "MyText",
        :passage => "MyText",
        :que_text => "MyText",
        :sol_text => "MyText",
        :option_set_count => 2,
        :que_image => "MyText",
        :sol_image => "MyText",
        :di_location => "Di Location",
        :quantity_a => "MyText",
        :quantity_b => "MyText",
        :type => nil,
        :topic => nil,
        :section => nil
      ),
      stub_model(Question,
        :sequence_no => 1,
        :header => "MyText",
        :instruction => "MyText",
        :passage => "MyText",
        :que_text => "MyText",
        :sol_text => "MyText",
        :option_set_count => 2,
        :que_image => "MyText",
        :sol_image => "MyText",
        :di_location => "Di Location",
        :quantity_a => "MyText",
        :quantity_b => "MyText",
        :type => nil,
        :topic => nil,
        :section => nil
      )
    ])
  end

  it "renders a list of questions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Di Location".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
