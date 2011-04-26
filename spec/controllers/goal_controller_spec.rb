require 'spec_helper'

describe GoalController do
  render_views

  describe "POST 'create'" do

    before :each do
      @user = test_sign_in Factory :user
    end

    describe "failure" do

      before :each do
        @attr = { :title => "", :description => "" }
      end

      it "should not create a new Goal" do
        lambda do
          post :create, :goal => @attr
        end.should_not change(Goal, :count).by 1
      end


    end
  end
end
