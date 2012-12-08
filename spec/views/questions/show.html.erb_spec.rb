require 'spec_helper'

describe "questions/show" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/2/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/Di Location/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
  end
end
