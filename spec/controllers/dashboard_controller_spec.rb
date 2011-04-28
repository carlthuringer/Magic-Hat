require 'spec_helper'

describe DashboardController do
  render_views

  before :each do
    @base_title = "Magic Hat"
  end

  describe "GET 'index'" do

    describe "when not signed in" do

      it "should redirect to the signin page" do
        get 'index'
        response.should redirect_to signin_path
      end
    end

    describe "signed in users" do

      before :each do
        @user = test_sign_in Factory :user
        @goal = Factory(:goal, :user => @user)
        @task = Factory(:task, :goal => @goal)
        get 'index'
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title", :content => @base_title + " | Dashboard")
      end

      it "should show the user's goals" do
        response.should have_selector("tr>td", :content => @goal.title)
      end

      it "should have edit and delete links for my goals" do
        response.should have_selector('td>a', :content => "Edit")
        response.should have_selector('input', :type => "submit", :value => "Delete")
      end

      describe "task display" do

        it "Should display the tasks in a <tr><td> under the goal" do
          response.should have_selector('tr>td', :content => @task.description)
        end

        it "should have edit and delete links for my tasks" do
          response.should have_selector('td>a', :content => "Edit")
          response.should have_selector('input', :type => "submit", :value => "Delete")
        end
      end
    end
  end
end
