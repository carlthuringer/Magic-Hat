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
        @habits = []
        2.times { @habits << Factory(:habit, :user => @user) }
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
          response.should have_selector("form", :id => "habit_edit_#{habit.id}")
        end
      end
    end

  end

end
