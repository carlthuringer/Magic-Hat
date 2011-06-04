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
        4.times { Factory(:goal, :user => @user) }
        @goals = @user.goals
        @task = Factory(:task, :goal => @goal)
        9.times { Factory(:task, :goal => @goal) }
        @important_tasks = @user.important_tasks

        get 'index'
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title", :content => @base_title + " | Dashboard")
      end

      describe "stats display" do

        it "should show a table with 4 rows" do
          response.should have_selector('table')
          response.should have_selector('tr', :count => 4)
        end

        it "should show a table with 28 cells" do
          response.should have_selector('td', :count => 28)
        end

        it "should show a table with 4 row headings" do
          response.should have_selector('th', :count => 4)
        end
      end

      describe "goal display" do

        it "should show the user's goals" do
          @goals.each do |goal|
            response.should contain(@goal.title)
          end
        end

        it "should have a form for each goal" do
          @goals.each do |goal|
            response.should have_selector('form', :id => "edit_goal_#{goal.id}")
          end
        end 
      end

      describe "task display" do

        it "Should include a form for each task" do
          @important_tasks.each do |task|
            response.should have_selector('form', :id => "edit_task_#{task.id}")
          end
        end

        it "Should include the top five deadline soonest or oldest created tasks" do
          @important_tasks.each do |task|
            response.should have_selector("#task_complete_#{task.id}")
          end
        end

        it "should have edit and delete links for my tasks" do
          # response.should have_selector('a', :content => "Edit", :href => "/tasks/#{@task.id}/edit")
          # response.should have_selector('a', :content => "Delete")
        end

        it "should have a link for each task" do
          # response.should have_selector('a', :href => complete_toggle_task_path( @task ))
        end
      end

      describe "statistics" do

        before :each do
          5.times do
            Factory(:task, :goal => @goal, :complete => Time.now)
          end
          get :index
        end
        it "should display today's total" do
          response.should contain(@user.tasks_completed_today.to_s)
        end

        it "should display the current velocity" do
          response.should contain(@user.velocity.to_s)
        end
      end
    end
  end

  describe "GET 'shelved'" do
    # before :each do
    #   @user = test_sign_in Factory :user
    #   @goal = Factory(:goal, :user => @user)
    #   @shelved_goal = Factory(:goal, :user => @user, :title => "INACTIVE GOAL", :shelved => true)
    #   @task = Factory(:task, :goal => @goal)
    # end

    # it "should be successful" do
    #   get 'shelved'
    #   response.should render_template(:index)
    # end

  end
end
