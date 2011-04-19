require 'spec_helper'

describe '/home/index.html.haml' do
  context "anonymous users" do
    before(:each) do
      render
    end

    it "includes a login link" do
      rendered.should have_selector('a', :content => "Sign In")
    end

    it "includes a register link" do
      rendered.should have_selector('a', :content => "Register")
    end

  end

  context "logged-in users" do
    before(:each) do
      user = Factory(:user)
      sign_in user
      render
    end

    it "hides the login/register links when I'm logged in." do
      rendered.should_not have_selector('ul', :class => "unauthenticated")
    end

  end
end
