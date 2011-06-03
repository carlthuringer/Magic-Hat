require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Magic Hat"
  end

  describe "GET 'home'" do

    describe "when not signed in" do

      before :each do
        get 'home'
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title",
          :content => @base_title )
      end
    end

    describe "when signed in" do

      before :each do
        @user = test_sign_in Factory :user
        get 'home'
      end

      it "should redirect to the dashboard" do
        response.should redirect_to dashboard_path
      end
    end
  end
end
