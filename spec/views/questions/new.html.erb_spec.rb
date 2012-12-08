require 'spec_helper'

describe "questions/new" do
  before(:each) do
    assign(:question, stub_model(Question,
      :sequence_no => 1,
      :header => "MyText",
      :instruction => "MyText",
      :passage => "MyText",
      :que_text => "MyText",
      :sol_text => "MyText",
      :option_set_count => 1,
      :que_image => "MyText",
      :sol_image => "MyText",
      :di_location => "MyString",
      :quantity_a => "MyText",
      :quantity_b => "MyText",
      :type => nil,
      :topic => nil,
      :section => nil
    ).as_new_record)
  end

  it "renders new question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => questions_path, :method => "post" do
      assert_select "input#question_sequence_no", :name => "question[sequence_no]"
      assert_select "textarea#question_header", :name => "question[header]"
      assert_select "textarea#question_instruction", :name => "question[instruction]"
      assert_select "textarea#question_passage", :name => "question[passage]"
      assert_select "textarea#question_que_text", :name => "question[que_text]"
      assert_select "textarea#question_sol_text", :name => "question[sol_text]"
      assert_select "input#question_option_set_count", :name => "question[option_set_count]"
      assert_select "textarea#question_que_image", :name => "question[que_image]"
      assert_select "textarea#question_sol_image", :name => "question[sol_image]"
      assert_select "input#question_di_location", :name => "question[di_location]"
      assert_select "textarea#question_quantity_a", :name => "question[quantity_a]"
      assert_select "textarea#question_quantity_b", :name => "question[quantity_b]"
      assert_select "input#question_type", :name => "question[type]"
      assert_select "input#question_topic", :name => "question[topic]"
      assert_select "input#question_section", :name => "question[section]"
    end
  end
end
