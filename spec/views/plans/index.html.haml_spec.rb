require 'spec_helper'

describe "plans/index.html.haml" do
  before(:each) do
    assign(:plans, [
      stub_model(Plan,
        :description => "MyText",
        :completed => false
      ),
      stub_model(Plan,
        :description => "MyText",
        :completed => false
      )
    ])
  end

  it "renders a list of plans" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "dd>h3", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "dt>p", :text => "Completed? " + false.to_s, :count => 2
  end
end
