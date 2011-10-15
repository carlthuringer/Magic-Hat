require 'spec_helper'

describe DashboardController do

  describe "GET 'index'" do

    describe "when not signed in" do

      it "should redirect to the signin page" do
        get 'index'
        response.should redirect_to signin_path
      end
    end

    describe "signed in users" do

      before do
        @user = mock(User).as_null_object
        controller.stub(:authenticate).and_return(true)
        controller.stub(:current_user).and_return(@user)
      end

      it "Sets the body class" do
        get :index
        assigns(:body_class).should == "dashboard"
      end

      it "sets the title" do
        get :index
        assigns(:title).should == "Dashboard"
      end

      it "gets the user's groups" do
        @user.should_receive(:groups)
        get :index
      end

      it "sets the groups" do
        @user.stub(:groups).and_return( groups = mock(Object))
        get :index
      end

      it "gets the user's important tasks" do
        @user.should_receive(:important_tasks)
        get :index
      end

      it "sets the important tasks" do
        @user.stub(:important_tasks).and_return( tasks = mock(Object))
        get :index
        assigns(:important_tasks).should == tasks
      end

      it "gets the user's history" do
        @user.should_receive(:history)
        get :index
      end

      it "sets the history" do
        @user.stub(:history).and_return( history = mock(Object))
        get :index
        assigns(:history).should == history
      end

      it "finds invitations that match the user's email" do
        @user.stub(:email).and_return("me@b.com")
        invitation = mock(Invitation, :user_email => "me@b.com")
        Invitation.should_receive(:where).
          with(:user_email => @user.email)
        get :index
      end

      it "sets the invitations" do
        Invitation.stub(:where).and_return( invitation = mock(Object))
        get :index
        assigns(:invitations).should == invitation
      end

      it "builds a task for the user" do
        user_tasks = mock(Task)
        @user.stub(:tasks).and_return(user_tasks)
        user_tasks.stub(:build).and_return(task = mock(Object))
        user_tasks.should_receive(:build)
        get :index
      end

      it "sets the task" do
        @user.stub_chain(:tasks, :build).and_return(task = mock(Object))
        get :index
        assigns(:task).should == task
      end
    end
  end
end
