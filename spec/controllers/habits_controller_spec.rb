require 'spec_helper'

describe HabitsController do
  render_views

  describe "GET index" do

    describe "as anonymous user" do

      it "should redirect to signin" do
        get :index
        response.should redirect_to signin_path
      end
    end

    describe "as authenticated user" do

      before :each do
        @user = test_sign_in Factory :user
        @goal = Factory :goal, :user => @user
        @tasks = []
        2.times { @tasks << Factory(:task, :goal => @goal) }
        @habits = []
        @tasks.each do |task|
          @habits << task.create_habit(:description => task.description,
            :goal => task.goal, :schedule_atts => { :repeat => '1',
              :start_date => Time.now.to_s, :interval_unit => 'day',
              :interval => '2' } )
        end
        get :index
      end

      it "should be successful" do
        response.should be_success
      end

      it "has all of a user's Habits" do
        response.should have_selector("div.habit", :count => 2)
      end

      it "has a form for each habit" do
        @habits.each do |habit|
          response.should have_selector("form", :id => "edit_habit_#{habit.id}")
        end
      end

      describe "editing form fields" do

        it "has a field for the date" do
          response.should have_selector('input',
              :id => "habit_schedule_attributes_date")
        end

        it "has a field for the interval" do
          response.should have_selector('input',
              :id => "habit_schedule_attributes_interval")
        end

        it "has a field for the interval unit" do
          response.should have_selector('input',
              :id => "habit_schedule_attributes_interval_unit")
        end

        it "has a hidden field for the repeat flag" do
          response.should have_selector('input', :type => 'hidden',
              :id => "habit_schedule_attributes_repeat")
        end
      end
    end
  end

  describe "GET new" do

    before :each do
      @user = test_sign_in Factory :user
      get :new
    end

    it "should be successful" do
      response.should be_successful
    end

    it "should have the right title" do
      response.should have_selector('title', :content => "Magic Hat | New Habit")
    end

    it "should have a form for the habit" do
      response.should have_selector('form', :id => "new_habit")
    end
  end

  describe "POST create" do

    before :each do
      @user = test_sign_in Factory :user
    end

    describe "failure" do

      before :each do
        @attr = {:description => ""}
      end

      it "shouldn't create a habit" do
        expect {
          post :create, :habit => @attr
        }.to_not change(Habit, :count).by 1
      end

      it "should re-render the habit" do
        post :create, :habit => @attr
        response.should render_template 'new'
      end
    end

    describe "success" do

      before :each do
        @attr = { :description => "Testing a habit", :start_date => Time.now.to_s,
          :interval_unit => "day", :interval => "2", :repeat => "1" }
      end

      it "should create a habit" do
        expect {
          post :create, :habit => @attr
        }.to change(Habit, :count).by 1
      end

      it "redirects to the dashboard" do
        post :create, :habit => @attr
        response.should redirect_to dashboard_path
      end
    end
  end

end
