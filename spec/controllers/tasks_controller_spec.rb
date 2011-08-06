require 'spec_helper'

describe TasksController do
  render_views

  describe "GET 'new'" do

    before :each do
      @user = test_sign_in Factory :user
      @goal = Factory(:goal, :user => @user)
      get :new, :goal_id => @goal.id
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector('title', :content => "Magic Hat | New Task")
    end


    it "should have a form with the right fields" do
      response.should have_selector('input', :id => "task_description")
    end
  end

  describe "POST 'create'" do

    before :each do
      @user = test_sign_in Factory :user
      @goal = Factory(:goal, :user => @user)
      @attr = {:description => "POST 'create'", :goal_id => @goal.id,
        :schedule_attributes => { :repeat => "0" }}
    end

    describe "failure" do

      it "should not create a new task with an empty description" do
        expect {
          @attr[:description] = ""
          post :create, :task => @attr
          response.should render_template 'new'
        }.to_not change(Task, :count).by 1
      end
    end

    describe "success" do

      it "should create a new task" do
        expect {
          post :create, :task => @attr
          response.should redirect_to @goal
        }.to change(Task, :count).by 1
      end
    end
  end

  describe "GET 'edit'" do

    before :each do
      @user = test_sign_in Factory :user
      @goal = Factory(:goal, :user => @user)
      @task = Factory(:task, :goal => @goal)
    end

    describe "non habit" do

      before :each do
        get :edit, :id => @task
      end

      it "should be successful" do
        response.should be_successful
      end

      it "should have the right title" do
        response.should have_selector('title', :content => "Magic Hat | Edit Task")
      end

      it "should have a heading indicating the parent goal" do
        response.should have_selector('h2', :content => @goal.title)
      end

      it "should have a field to edit the description." do
        response.should have_selector('input', :id => "task_description")
      end

      it "should have a field to edit the deadline." do
        response.should have_selector('input', :id => "task_deadline_string")
      end

      it "should have a div with class hidden" do
        response.should have_selector('div', :class => "habit-fields hidden")
      end
    end

    describe "habits" do

      before :each do
        @task.toggle_habit
        get :edit, :id => @task
      end

      it "has a field for the start date" do
        @task.toggle_habit
        response.should have_selector('select',
          :id => "task_schedule_attributes_start_date_1i")
      end
    end
  end

  describe "PUT 'update'" do

    before :each do
      @user = test_sign_in Factory :user
      @goal = Factory(:goal, :user => @user)
      @task = Factory(:task, :goal => @goal)
    end

    describe "failure" do

      before :each do
        @attr = { :description => "", :active => "0", :schedule_attributes =>
          { :repeat => "0" } }
        put :update, :id => @task, :task => @attr
      end

      it "should re-render the edit page" do
        response.should render_template 'edit'
      end

      it "should have the right title" do
        response.should have_selector('title', :content => "Magic Hat | Edit Task")
      end

      it "should have a header indicating the parent goal" do
        response.should have_selector('h2', :content => @goal.title)
      end
    end

    describe "success" do

      before :each do
        @attr = { :description => "SHOULD BE EDITED", 
          :deadline_string => "11-23-2012", :schedule_attributes =>
          { :repeat => "0"}}
      end

      describe "regular submission" do

        before :each do 
          put :update, :id => @task, :task => @attr
        end

        it "should change the Task's attributes" do
          @task.reload
          @task.description.should == @attr[:description]
        end

        it "should redirect to the goal" do
          response.should redirect_to @goal
        end

        it "should have a flash message" do
          flash[:success].should =~ /task updated/i
        end
      end

      describe "habit submission" do

        before :each do
          put :update, :id => @task, :task => @attr.merge( :schedule_attributes =>
            { :repeat => "1", :start_date => Time.now.to_s, :interval_unit => "day", :interval=> "2"}),
            :commit => "habit"
        end

        it "becomes a habit" do
          @task.reload
          @task.should be_habit
        end

        it "is changed back into a regular task" do
          put :update, :id => @task, :task => @attr.merge( :schedule_attributes =>
            { :repeat => "0", :start_date => Time.now.to_s, :interval_unit => "day", :interval=> "2"}),
            :commit => "habit"
          @task.reload
          @task.should_not be_habit
        end

      end
    end
  end

  describe "PUT 'complete'" do

    before :each do
      # Prepare 5 tasks and collect them.
      @user = test_sign_in Factory :user
      @goal = Factory(:goal, :user => @user)
      5.times do
        Factory(:task, :goal => @goal)
      end
      @tasks = @goal.tasks
    end

    describe "failure" do
      # A submission with no selected tasks is considered a failure
      # But there is no error, it simply redirects to the dashboard
      it "should redirect to the dashboard" do
        attr = {:ids => []}
        put :complete
        response.should redirect_to dashboard_path
      end
    end

    describe "success" do

      it "should set tasks 1 and 3 as complete but no others" do
        attr = [@tasks[1].id, @tasks[3].id]
        put :complete, :ids => attr
        @tasks.each do |task|
          task.reload
        end
        @tasks[0].active?.should == true
        @tasks[1].active?.should == false
        @tasks[2].active?.should == true
        @tasks[3].active?.should == false
        @tasks[4].active?.should == true
      end

      it "should set true tasks 1, 3 and 4 to false, but leave 0 and 2 alone" do
        attr = [@tasks[0].id, @tasks[2].id]
        @tasks.each do |task|
          task.mark_complete
        end
        put :complete, :ids => attr
        @tasks.each do |task|
          task.reload
        end
        @tasks[0].active?.should == false
        @tasks[1].active?.should == true
        @tasks[2].active?.should == false
        @tasks[3].active?.should == true
        @tasks[4].active?.should == true
      end

      it "should set task 0 true, then set 1 and 2 true, and all should remain true" do
        attr = [@tasks[0].id]
        put :complete, :ids => attr
        attr = [@tasks[1].id, @tasks[2].id]
        put :complete, :ids => attr
        @tasks.each do |task|
          task.reload
        end
        @tasks[0].active?.should == false
        @tasks[1].active?.should == false
        @tasks[2].active?.should == false
      end
    end
  end

  describe "DELETE 'destroy'" do

    before :each do
      @user = Factory :user
      @goal = Factory(:goal, :user => @user)
      @task = Factory(:task, :goal => @goal)
    end

    describe "as a non-authenticated user" do

      it "should redirect to the signin path" do
        delete :destroy, :id => @task
        response.should redirect_to signin_path
      end
    end

    describe "as an authenticated user" do

      before :each do
        test_sign_in @user
      end

      it "should destroy the task" do
        expect {
          delete :destroy, :id => @task
        }.to change(Task, :count).by -1
      end

      it "should redirect to the goal" do
        delete :destroy, :id => @task
        response.should redirect_to goal_path @task.goal_id
      end
    end
  end

  describe "authentication of actions" do

    before :each do
      @user = Factory :user
      @goal = Factory(:goal, :user => @user)
      @task = Factory(:task, :goal => @goal)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @task
        response.should redirect_to signin_path
      end

      it "should deny access to 'update'" do
        put :update, :id => @task, :task => { :description => "Test description" }
        response.should redirect_to signin_path
      end

      it "should deny access to 'new'" do
        get :new, :goal_id => @goal
        response.should redirect_to signin_path
      end

      it "should deny access to 'create'" do
        post :create, :task => { :description => "Test description", :goal_id => @goal.id }
        response.should redirect_to signin_path
      end

      it "should deny access to 'destroy'" do
        delete :destroy, :id => @task
        response.should redirect_to signin_path
      end
    end

    describe "for signed-in users" do

      before :each do
        test_sign_in @user
        @other_user = Factory(:user)
        @other_goal = Factory(:goal, :user => @other_user)
        @other_task = Factory(:task, :goal => @other_goal)
      end

      it "should not allow user to POST 'create' task for goal they don't own" do
        post :create, :task => { :description => "POST 'create' test", :goal_id => @other_goal.id,
          :schedule_attributes => { :repeat => "0" } }
        response.should redirect_to @other_goal
      end

      it "should not allow user to PUT 'update' task they don't own" do
        put :update, :id => @other_task, :task => { :description => "PUT 'update' test" }
        response.should redirect_to dashboard_path
      end

      it "should not allow user to DELETE 'destroy' task they don't own" do
        delete :destroy, :id => @other_task
        response.should redirect_to dashboard_path
      end
    end
  end
end
