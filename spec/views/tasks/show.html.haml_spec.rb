require 'spec_helper'

describe "tasks/show.html.haml" do
  before(:each) do
    @task = assign(:task, stub_model(Task,
      :description => "MyText",
      :completed => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
