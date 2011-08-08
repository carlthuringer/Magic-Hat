require 'spec_helper'

describe GoalsController do

  context "Unauthenticated user" do

    describe "#new" do

      it "redirects to signin" do
        get :new
        response.should redirect_to signin_path
      end
    end

    describe "#create" do

      it "redirects to signin" do
        post :create
        response.should redirect_to signin_path
      end
    end

    describe "#show" do

      it "redirects to signin" do
        get :show, :id => 1
        response.should redirect_to signin_path
      end
    end

    describe "#edit" do

      it "redirects to signin" do
        get :edit, :id => 1
        response.should redirect_to signin_path
      end
    end

    describe "#update" do

      it "redirects to signin" do
        put :update, :id => 1
        response.should redirect_to signin_path
      end
    end

    describe "#destroy" do

      it "redirects to signin" do
        delete :destroy, :id => 1
        response.should redirect_to signin_path
      end
    end
  end

  context "Authenticated and Authorized user" do

    before do
      @user = mock(User).as_null_object
      controller.stub!(:current_user).and_return(@user)
      controller.stub!(:authenticate)
    end

    describe "#new" do

      it "sets the title" do
        get :new
        assigns(:title).should == "New Goal"
      end

      it "sets the user" do
        get :new
        assigns(:user).should == @user
      end

      it "sets up a goal" do
        user_goals = mock(Object)
        @user.stub(:goals).and_return(user_goals)
        user_goals.stub(:new).and_return(goal = mock(Object))
        user_goals.should_receive(:new)
        get :new
      end

      it "sets the goal" do
        goal = mock(Object)
        @user.stub_chain(:goals, :new).and_return(goal)
        get :new
        assigns(:goal).should == goal
      end

      it "sets up the header back button" do
        get :new
        assigns[:header_back][:title].should == "Back"
        assigns[:header_back][:url].should == dashboard_path
      end
    end

    describe "#create" do

      before do
        @user_goals = mock(Object)
        @user.stub(:goals).and_return(@user_goals)
        @user_goals.stub(:build).and_return( @goal = stub_model(Goal).as_null_object)
      end

      it "builds the goal" do
        @user_goals.should_receive(:build).with("test" => "test")
        post :create, :goal => { "test" => "test" }
      end

      it "saves the goal" do
        @goal.should_receive(:save)
        post :create, :goal => {}
      end

      it "sets the flash message" do
        @goal.stub(:save).and_return(true)
        post :create, :goal => {}
        flash[:success].should_not be_nil
      end

      it "redirects to the goal" do
        @goal.stub(:save).and_return(true)
        post :create, :goal => @goal
        response.should redirect_to @goal
      end

      describe "failure" do

        it "renders the new template" do
          @goal.stub(:save).and_return(false)
          post :create, :goal => {}
          response.should render_template :new
        end
      end
    end

    describe "#show" do

      before do
        Goal.stub(:find).and_return( @goal = mock(Object).as_null_object)
      end

      it "finds the goal" do
        Goal.should_receive(:find)
        get :show, :id => 1
      end

      it "assigns the goal" do
        get :show, :id => 1
        assigns(:goal).should == @goal
      end

      it "looks up the user's active goals" do
        @user.should_receive(:active_goals)
        get :show, :id => 1
      end

      it "assigns the active goals" do
        @user.stub(:active_goals).and_return( goals = mock(Object))
        get :show, :id => 1
        assigns(:goals).should == goals
      end

      it "looks up the user's history" do
        @user.should_receive(:history)
        get :show, :id => 1
      end

      it "assigns the history" do
        @user.stub(:history).and_return( history = mock(Object))
        get :show, :id => 1
        assigns(:history).should == history
      end

      it "finds the goal's title" do
        @goal.should_receive(:title)
        get :show, :id => 1
      end

      it "assigns the title" do
        @goal.stub(:title).and_return(the_title = "title")
        get :show, :id => 1
        assigns(:title).should == the_title
      end

      it "gets the tasks associated with the goal" do
        @goal.should_receive(:tasks)
        get :show, :id => 1
      end

      it "assigns the tasks" do
        @goal.stub(:tasks).and_return(tasks = [])
        get :show, :id => 1
        assigns(:tasks).should == tasks
      end

      it "looks up the goal's incomplete tasks" do
        @goal.should_receive(:incomplete_tasks)
        get :show, :id => 1
      end

      it "assigns the incomplete tasks" do
        @goal.stub(:incomplete_tasks).and_return(incomplete_tasks = [])
        get :show, :id => 1
        assigns(:incomplete_tasks).should == incomplete_tasks
      end

      it "looks up the goal's complete tasks" do
        @goal.should_receive(:complete_tasks)
        get :show, :id => 1
      end

      it "assigns the complete tasks" do
        @goal.stub(:complete_tasks).and_return(complete_tasks = [])
        get :show, :id => 1
        assigns(:complete_tasks).should == complete_tasks
      end
    end

    describe "#edit" do

      before do
        @goal = mock(Object)
        Goal.stub(:find).and_return(@goal)
      end
      it "sets the title" do
        get :edit, :id => 1
        assigns(:title).should_not be_nil
      end

      it "finds the goal" do
        Goal.should_receive(:find).with(1)
        get :edit, :id => 1
      end

      it "assigns the goal" do
        get :edit, :id => 1
        assigns(:goal).should == @goal
      end
    end

    describe "#update" do

      before do
        @goal = mock_model(Goal).as_null_object
        Goal.stub(:find).and_return(@goal)
        controller.stub(:authorized_user).and_return(true)
      end

      it "finds the goal" do
        Goal.should_receive(:find).and_return(@goal)
        put :update, :id => 1
      end

      it "updates the goal's attributes" do
        atts = "foobar"
        @goal.should_receive(:update_attributes).with(atts)
        put :update, :id => 1, :goal => atts
      end

      describe "success" do

        before do
          @goal.stub(:update_attributes).and_return(true)
        end

        it "sets a flash message" do
          put :update, :id => 1
          flash[:success].should_not be_nil
        end

        it "redirects to the goal" do
          put :update, :id => 1, :goal => @goal
          response.should redirect_to @goal
        end
      end

      describe "failure" do

        before do
          @goal.stub(:update_attributes).and_return(false)
        end

        it "sets the title" do
          put :update, :id => 1
          assigns(:title).should_not be_nil
        end

        it "renders the edit template" do
          put :update, :id => 1
          response.should render_template :edit
        end
      end
    end

    describe "#destroy" do

      before do
        @goal = mock(Object).as_null_object
        Goal.stub(:find).and_return(@goal)
      end

      it "should find the goal" do
        Goal.should_receive(:find).with(1)
        delete :destroy, :id => 1
      end

      it "should destroy the goal" do
        @goal.should_receive(:destroy)
        delete :destroy, :id => 1
      end

      it "should redirect to the dashboard" do
        delete :destroy, :id => 1
        response.should redirect_to dashboard_path
      end
    end
  end
end
