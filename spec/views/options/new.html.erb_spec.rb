require 'spec_helper'

describe "options/new" do
  before(:each) do
    assign(:option, stub_model(Option,
      :content => "MyText",
      :correct => false,
      :question => nil
    ).as_new_record)
  end

  it "renders new option form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => options_path, :method => "post" do
      assert_select "textarea#option_content", :name => "option[content]"
      assert_select "input#option_correct", :name => "option[correct]"
      assert_select "input#option_question", :name => "option[question]"
    end
  end
end
