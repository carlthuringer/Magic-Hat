require 'spec_helper'

describe GroupsController do

  before do
    @user = mock(User).as_null_object
    controller.stub(:current_user).and_return(@user)
  end

  describe "#new" do

    it "assigns the title" do
      get :new
      assigns(:title).should_not be_empty
    end

    it "assigns the user" do
      get :new
      assigns(:user).should == @user
    end

    it "sets up a new group" do
      user_groups = mock(Object).as_null_object
      @user.stub(:groups).and_return(user_groups)
      user_groups.should_receive(:build)
      get :new
    end

    it "assigns the group" do
      group = mock(Group)
      @user.stub_chain(:groups, :build).and_return(group)
      get :new
      assigns(:group).should == group
    end
  end

  describe "successful #create" do

    before do
      @user_groups = mock(Object).as_null_object
      @user.stub(:groups).and_return(@user_groups)
      @group = mock_model(Group)
      @user_groups.stub(:build).and_return(@group)
      @group.stub(:save).and_return(true)
    end

    it "builds a group with the parameters" do
      atts = {"foo" => "bar"}
      @user_groups.should_receive(:build).with(atts)
      post :create, :group => atts
    end

    it "saves the group" do
      @group.should_receive(:save)
      post :create
    end

    it "appends the group to the user's relationship" do
      @user_groups.should_receive(:<<).with(@group)
      post :create
    end

    it "sets a flash message" do
      post :create
      flash[:success].should_not be_empty
    end

    it "redirects to the group" do
      post :create
      response.should redirect_to @group
    end
  end

  describe "failed #create" do

    before do
      @user_groups = mock(Object).as_null_object
      @user.stub(:groups).and_return(@user_groups)
      @group = mock_model(Group)
      @user_groups.stub(:build).and_return(@group)
      @group.stub(:save).and_return(false)
    end

    it "re-renders the new group template" do
      post :create
      response.should render_template :new
    end
  end

  describe "successful #update" do

    before do
      @group = mock_model(Group)
      Group.stub(:find).and_return(@group)
      @group.stub(:update_attributes).and_return(true)
    end

    it "finds the group based on its id" do
      Group.should_receive(:find).with(12)
      put :update, :id => 12
    end

    it "Updates the group's attributes" do
      atts = {"foo" => "bar"}
      @group.should_receive(:update_attributes).with(atts)
      put :update, :id => 1, :group => atts
    end

    it "sets a flash message" do
      put :update, :id => 1
      flash[:success].should_not be_empty
    end

    it "redirects to the group" do
      put :update, :id => 1
      response.should redirect_to @group
    end
  end

  describe "failed #update" do

    before do
      @group = mock_model(Group)
      Group.stub(:find).and_return(@group)
      @group.stub(:update_attributes).and_return(false)
    end

    it "re-renders the show group template" do
      put :update, :id => 1
      response.should render_template :show
    end
  end

  describe "#show" do

    before do
      @group = mock(Group).as_null_object
      Group.stub(:find).and_return(@group)
      @user_groups = mock(Object).as_null_object
      @user.stub(:groups).and_return(@user_groups)
    end

    it "finds the group by id" do
      Group.should_receive(:find).with(12)
      get :show, :id => 12
    end

    it "assigns the group" do
      get :show, :id => 12
      assigns(:group).should == @group
    end

    it "gathers the user's groups" do
      @user.should_receive(:groups)
      get :show, :id => 1
    end

    it "assigns the groups" do
      get :show, :id => 1
      assigns(:groups).should == @user_groups
    end

    it "looks up the user's incomplete tasks" do
      @group.should_receive(:incomplete_tasks)
      get :show, :id => 1
    end

    it "assigns the incomplete tasks" do
      incomplete_tasks = mock(Object)
      @group.stub(:incomplete_tasks).and_return(incomplete_tasks)
      get :show, :id => 1
      assigns(:incomplete_tasks).should == incomplete_tasks
    end

    it "looks up the user's complete tasks" do
      @group.should_receive(:complete_tasks)
      get :show, :id => 1
    end

    it "assigns the complete tasks" do
      complete_tasks = mock(Object)
      @group.stub(:complete_tasks).and_return(complete_tasks)
      get :show, :id => 1
      assigns(:complete_tasks).should == complete_tasks
    end

    it "looks up the group's tasks" do
      @group.should_receive(:tasks)
      get :show, :id => 1
    end

    it "assigns the tasks" do
      @group.stub(:tasks).and_return(tasks = mock(Object))
      get :show, :id => 1
      assigns(:tasks).should == tasks
    end

    it "looks up the user's history" do
      @user.should_receive(:history)
      get :show, :id => 1
    end

    it "assigns the user's history" do
      @user.stub(:history).and_return(history = mock(Object))
      get :show, :id => 1
      assigns(:history).should == history
    end
  end

  describe "#remove_member" do
    it "removes the member from the group" do
      group = mock_model(Group)
      Group.stub(:find).and_return(group)
      group_memberships = stub
      group.stub(:memberships).and_return(group_memberships)
      membership = stub
      group_memberships.should_receive(:where).with(:user_id => 2).and_return(membership)

      group_memberships.should_receive(:destroy).with(membership)
      delete :remove_member, :id => 1, :user_id => 2
    end
  end

end
