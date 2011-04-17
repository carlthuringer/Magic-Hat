require 'spec_helper'

describe "plans/new.html.haml" do
  before(:each) do
    assign(:plan, stub_model(Plan,
      :description => "MyText",
      :completed => false
    ).as_new_record)
  end

  it "renders new plan form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => plans_path, :method => "post" do
      assert_select "textarea#plan_description", :name => "plan[description]"
      assert_select "input#plan_completed", :name => "plan[completed]"
    end
  end
end
