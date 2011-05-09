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
        @shelved_goal = Factory(:goal, :user => @user, :title => "INACTIVE GOAL", :shelved => true)
        @task = Factory(:task, :goal => @goal)
        get 'index'
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title", :content => @base_title + " | Dashboard")
      end

      it "should show the user's active goals" do
        response.should have_selector("tr>td", :content => @goal.title)
        response.should_not have_selector("tr>td", :content => @shelved_goal.title)
      end

      it "should have edit, delete and shelve links for my goals" do
        response.should have_selector('a', :content => "Edit")
        response.should have_selector('input', :type => "submit", :value => "Delete")
        response.should have_selector('a', :content => "Shelve")
      end

      it "should have a link to my shelved goals" do
        response.should have_selector('a', :content => "Shelved")
      end

      describe "task display" do

        it "Should display the tasks in a <tr><td> under the goal" do
          response.should have_selector('tr>td', :content => @task.description)
        end

        it "should have edit and delete links for my tasks" do
          response.should have_selector('a', :content => "Edit", :href => "/tasks/#{@task.id}/edit")
          response.should have_selector('input', :type => "submit", :value => "Delete")
        end

        it "should have a checkbox for each task" do
          response.should have_selector('input', :type => "checkbox")
        end
      end

      describe "statistics" do

        it "should display today's total" do
          response.should have_selector('h3', :id => "tasks-completed")
        end

        it "should display the current velocity" do
          response.should have_selector('h3', :id => "velocity")
        end
      end
    end
  end

  describe "GET 'shelved'" do
    before :each do
      @user = test_sign_in Factory :user
      @goal = Factory(:goal, :user => @user)
      @shelved_goal = Factory(:goal, :user => @user, :title => "INACTIVE GOAL", :shelved => true)
      @task = Factory(:task, :goal => @goal)
    end

    it "should be successful" do
      get 'shelved'
      response.should render_template(:index)
    end

  end
end
