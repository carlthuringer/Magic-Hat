require 'spec_helper'

describe '/home/index.html.haml' do
  before(:each) do
    render
  end
  it "includes a login link" do
    rendered.should have_tag('a', "Sign In")
    assert_select "a", :text => "Sign In".to_s
  end

  it "includes a register link" do
    assert_select "a", :text => "Register".to_s
  end

  it "hides the login/register links when I'm logged in." do
    user = Factory(:user)
    sign_in user
  end
end
