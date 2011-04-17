require 'spec_helper'

describe "tasks/edit.html.haml" do
  before(:each) do
    @task = assign(:task, stub_model(Task,
      :description => "MyText",
      :completed => ""
    ))
  end

  it "renders the edit task form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tasks_path(@task), :method => "post" do
      assert_select "textarea#task_description", :name => "task[description]"
      assert_select "input#task_completed", :name => "task[completed]"
    end
  end
end
