class GroupsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => :update

  def new
    @title = "New Group"
    @user = current_user
    @group = current_user.groups.build
  end

  def create
    @group = current_user.groups.build params[:group]
    if @group.save
      current_user.groups << @group
      flash[:success] = "Group created!"
      redirect_to @group
    else
      render 'new'
    end
  end

  def update
    group = Group.find(params[:id])
    if group.update_attributes(params[:group])
      flash[:success] = "Group updated!"
      redirect_to group
    else
      render 'show'
    end
  end

  def show
    @group = Group.find params[:id]
    @groups = current_user.groups
    @history = current_user.history
  end

  private

  def authorized_user
    @group = Group.find(params[:id])
    redirect_to root_path unless current_user.groups.include? @group
  end
end
