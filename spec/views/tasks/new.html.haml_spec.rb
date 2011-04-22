require 'spec_helper'

describe "tasks/new.html.haml" do
  before(:each) do
    assign(:task, stub_model(Task,
      :description => "MyText",
      :completed => ""
    ).as_new_record)
    @plan = Plan.new
    @plan.stub(:model_name).and_return('Plan')
  end

  it "renders new task form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tasks_path, :method => "post" do
      assert_select "textarea#task_description", :name => "task[description]"
      assert_select "select#task_plan_id", :name => "task[plan_id]"
      assert_select "input#task_completed", :name => "task[completed]"
    end
  end
end
