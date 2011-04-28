require 'spec_helper'

describe GoalsController do
  render_views

  before :each do
    @base_title = "Magic Hat"
  end

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to signin_path
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to signin_path
    end
  end

  describe "GET 'new'" do

    before :each do
      @user = test_sign_in Factory :user
      get :new
    end

    it "should be successful" do
      response.should be_successful
    end

    it "should have the right title" do
      response.should have_selector('title', :content => @base_title + " | New Goal")
    end
  end

  describe "POST 'create'" do

    before :each do
      @user = test_sign_in Factory :user
    end

    describe "failure" do

      before :each do
        @attr = {:title => "", :description => ""}
      end

      it "should not create a goal" do
        lambda do
          post :create, :goal => @attr
        end.should_not change(Goal, :count).by 1
      end

      it "should re-render the goal" do
        post :create, :goal => @attr
        response.should render_template 'new'
      end
    end

    describe "success" do

      before :each do
        @attr = {:title => "A test title", :description => "Test description"}
      end

      it "should create a goal" do
        lambda do
          post :create, :goal => @attr
        end.should change(Goal, :count).by 1
      end

      it "should redirect to the dashboard" do
        post :create, :goal => @attr
        response.should redirect_to dashboard_path
      end

      it "should have a flash message" do
        post :create, :goal => @attr
        flash[:success].should =~ /goal created/i
      end
    end
  end

  describe "GET 'edit'" do

    before :each do
      @user = test_sign_in Factory :user
      @goal = Factory(:goal, :user => @user)
    end

    it "should be successful" do
      get :edit, :id => @goal
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @goal
      response.should have_selector('title', :content => @base_title + " | Edit Goal")
    end
  end

  describe "PUT 'update'" do

    before :each do
      @user = Factory :user
      @goal = Factory(:goal, :user => @user)
      @attr = {:title => "put update title", :description => "Description of the goal"}
    end

    describe "failure" do

      it "should redirect unauthorized users" do
        unauthorized_user = test_sign_in Factory(:user, :email => Factory(:email))
        put :update, :id => @goal, :goal => @attr
        response.should redirect_to root_path
      end

      it "should rerender with invalid attributes" do
        test_sign_in @user
        put :update, :id => @goal, :goal => @attr.merge( :title => "", :description => "")
        response.should render_template 'edit'
      end
    end

    describe "success" do

      before :each do
        test_sign_in @user
        put :update, :id => @goal, :goal => @attr
      end

      it "should redirect to the dashboard" do
        response.should redirect_to dashboard_path
      end

      it "should have a flash message" do
        flash[:success] =~ /goal updated/i
      end

      it "should modify the goal" do
        @goal.reload.title.should == @goal.title
      end
    end
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
        response.should have_selector('td>a', :content => "Delete")
      end

      describe "task display" do

        before :each do
        end

        it "Should display the tasks in a <tr><td> under the goal" do
          response.should have_selector('tr>td', :content => @task.description)
        end

        it "should have edit and delete links for my tasks" do
          response.should have_selector('td>a', :content => "Edit")
          response.should have_selector('td>a', :content => "Delete")
        end
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before :each do
        @user = Factory :user
        wrong_user = Factory(:user, :email => Factory(:email))
        test_sign_in wrong_user
        @goal = Factory(:goal, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @goal
        response.should redirect_to root_path
      end
    end

    describe "for an authorized user" do

      before :each do
        @user = test_sign_in Factory :user
        @goal = Factory(:goal, :user => @user)
      end

      it "should destroy the goal" do
        lambda do
          delete :destroy, :id => @goal
        end.should change(Goal, :count).by -1
      end
    end
  end

end
