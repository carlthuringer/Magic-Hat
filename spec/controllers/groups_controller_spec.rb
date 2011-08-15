require 'spec_helper'

describe GroupsController do

  before do
    @user = mock(User).as_null_object
    controller.stub(:current_user).and_return(@user)
  end

  describe "#new" do

    it "Sets up all variables" do
      group = mock(Group)
      user_groups = mock(Object)
      @user.stub_chain(:groups).and_return(user_groups)
      user_groups.should_receive(:build).and_return(group)
      get :new
      assigns(:title).should_not be_empty
      assigns(:user).should == @user
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

    it "builds and saves the group" do
      atts = {"foo" => "bar"}
      @user_groups.should_receive(:build).with(atts)
      @group.should_receive(:save)
      @user_groups.should_receive(:<<).with(@group)
      post :create, :group => atts
    end

    it "sets a flash message and redirects" do
      post :create
      flash[:success].should_not be_empty
      response.should redirect_to @group
    end
  end

  describe "failed #create" do

    it "re-renders the new group template" do
      @group = stub
      @user.stub_chain(:groups, :build).and_return(@group)
      @group.stub(:save).and_return(false)
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

    it "finds the group and updates its attributes" do
      Group.should_receive(:find).with('12')
      atts = {"foo" => "bar"}
      @group.should_receive(:update_attributes).with(atts)
      put :update, :id => 12, :group => atts
    end

    it "sets a flash message and redirects" do
      put :update, :id => 1
      flash[:success].should_not be_empty
      response.should redirect_to @group
    end
  end

  describe "failed #update" do

    before do
      @group = stub
      Group.stub(:find).and_return(@group)
      @group.stub(:update_attributes).and_return(false)
    end

    it "re-renders the show group template" do
      put :update, :id => 1
      response.should render_template :show
    end
  end

  describe "#show" do

    it "Assigns all variables" do
      group = stub.as_null_object
      Group.stub(:find).and_return(group)
      user_groups = stub.as_null_object
      @user.stub(:groups).and_return(user_groups)
      incomplete_tasks = stub
      complete_tasks = stub
      group.stub(:complete_tasks).and_return(complete_tasks)
      group.stub(:incomplete_tasks).and_return(incomplete_tasks)
      group.stub(:tasks).and_return(tasks = stub)
      @user.stub(:history).and_return(history = stub)

      Group.should_receive(:find).with('12')
      @user.should_receive(:groups)
      group.should_receive(:incomplete_tasks)
      group.should_receive(:complete_tasks)
      group.should_receive(:tasks)
      @user.should_receive(:history)

      get :show, :id => 12

      assigns(:group).should == group
      assigns(:groups).should == user_groups
      assigns(:incomplete_tasks).should == incomplete_tasks
      assigns(:complete_tasks).should == complete_tasks
      assigns(:tasks).should == tasks
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
      group_memberships.should_receive(:where).with(:user_id => "2").and_return(membership)

      group_memberships.should_receive(:destroy).with(membership)
      delete :remove_member, :id => 1, :user_id => 2
    end
  end

  describe "#destroy" do

    context "Authorized User" do

      it "finds the group and destroys it" do
        @user.stub_chain(:groups, :include?).and_return(true)
        group = stub
        Group.stub(:find).and_return(group)

        Group.should_receive(:find).with("12")
        group.should_receive(:destroy)

        delete :destroy, :id => "12"

      end
    end
  end
end
