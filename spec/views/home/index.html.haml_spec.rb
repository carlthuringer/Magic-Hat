require 'spec_helper'

describe '/home/index.html.haml' do

  it "includes a login link" do
    render
    assert_select "a", :text => "Sign In".to_s
  end
end
