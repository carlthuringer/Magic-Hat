require 'spec_helper'

describe TasksController do

  context "Unauthenticated, unauthorized users" do

    describe "#new" do

      it "redirects to signin" do
        get :new
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

    describe "#complete_toggle" do

      it "redirects to signin" do
        put :complete_toggle, :id => 1
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

  context "Authorized Users" do

    before do
      @current_user = mock(User)
      controller.stub!(:current_user).and_return(@current_user)
      controller.stub!(:authenticate)
    end

    describe "#new" do

      it "Builds the task" do
        new_task = mock(Task, :group_id => 12, :start_date= => stub, :interval_unit= => stub, :interval= => stub)
        @current_user.stub_chain(:tasks, :build).and_return(new_task)

        get :new, :group_id => 12
        assigns(:task).should == new_task
      end
    end

    describe "#create simple task" do

      describe "success" do
        before do
          @attributes = {"description" => "My new task"}
          @user_tasks = mock(Object).as_null_object
          @current_user.stub(:tasks).and_return(@user_tasks)
          @user_tasks.stub(:build).and_return( @task = mock(Task, @attributes).as_null_object)
        end

        it "Builds the task" do
          @user_tasks.should_receive(:build).with(@attributes)
          post :create, :task => @attributes
        end

        it "Saves the task" do
          @task.should_receive(:save)
          post :create, :task => @attributes
        end
      end

      describe "failure due to validation error" do
        before do
          @attributes = {"description" => ""}
          @user_tasks = mock(Object).as_null_object
          @current_user.stub(:tasks).and_return(@user_tasks)
          @user_tasks.stub(:build).and_return( @task = mock(Task, @attributes).as_null_object)
          @task.stub(:save).and_return(false)
        end

        it "renders the new form" do
          post :create, :task => @attributes
          response.should render_template "new"
        end

        it "Sets the title" do
          post :create, :task => @attributes
          assigns(:title).should == "New Task"
        end
      end
    end

    describe "#edit simple task" do

      before do
        @attributes = {"description" => ""}
        Task.stub(:find).and_return(
          @task = mock(Task, @attributes.merge(:id => 1)).as_null_object)
      end

      it "Sets the title" do
        get :edit, :id => @task.id
        assigns(:title).should == "Edit Task"
      end

      it "Finds the task" do
        get :edit, :id => @task.id
        # Task.should_receive(:find).and_return(@task)
        assigns(:task).should == @task
      end
    end

    describe "#update simple task" do

      before do
        @task = mock(Task).as_null_object
        Task.stub(:find).and_return(@task)
        controller.stub(:authorized_user).and_return(true)
      end

      it "Should find the task" do
        Task.should_receive(:find)
        put :update, :id => 1, :task => {}
      end

      context "Failure due to validation error" do
        before do
          @task.stub(:update_attributes).and_return(false)
        end

        it "Should render the edit form" do
          put :update, :id => 1, :task => {}
          response.should render_template :edit

        end

        it "Should set the title" do
          put :update, :id => 1, :task => {}
          assigns(:title).should == "Edit Task"
        end
      end

      context "Success" do

        it "Should update the attributes" do
          @task.should_receive(:update_attributes)
          put :update, :id => 1, :task => {}
        end

        it "Should set a flash message" do
          put :update, :id => 1, :task => {}
          flash[:success].should_not be_nil
        end

        it "Should redirect to root" do
          put :update, :id => 1, :task => {}
          response.should redirect_to root_path
        end
      end
    end

    describe "#complete_toggle" do

      before do
        @task = mock(Task).as_null_object
        Task.stub(:find).and_return(@task)
      end

      context "HTTP" do

        it "Should find the task" do
          Task.should_receive(:find)
          put :complete_toggle, :id => 1
        end

        it "Should check the task's complete status" do
          @task.should_receive(:incomplete_or_habit?)
          put :complete_toggle, :id => 1
        end

        context "Task is incomplete" do

          it "Should mark the task as complete" do
            @task.stub(:incomplete_or_habit?).and_return(true)
            @task.should_receive(:mark_complete)
            put :complete_toggle, :id => 1
          end
        end

        context "Task is complete" do

          it "Should mark the task as incomplete" do
            @task.stub(:incomplete_or_habit?).and_return(false)
            @task.should_receive(:clear_complete)
            put :complete_toggle, :id => 1
          end
        end

        it "Should redirect to the dashboard" do
          put :complete_toggle, :id => 1
          response.should redirect_to dashboard_path
        end
      end

      context "XHR" do

        it "Should render complete_toggle.js" do
          xhr :put, :complete_toggle, :id => 1
          response.should render_template :complete_toggle
        end

      end
    end

    describe "#destroy" do

      before do
        @task = mock(Task).as_null_object
        Task.stub(:find).and_return(@task)
      end

      it "Finds the task" do
        Task.should_receive(:find)
        delete :destroy, :id => 1
      end

      it "Destroys the task" do
        @task.should_receive(:destroy)
        delete :destroy, :id => 1
      end

      it "Redirects to the dashboard" do
        delete :destroy, :id => 1
        response.should redirect_to dashboard_path

      end
    end
  end
end
