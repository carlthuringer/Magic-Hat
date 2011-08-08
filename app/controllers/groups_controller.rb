class GroupsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:update, :remove_member]

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
    @incomplete_tasks = @group.incomplete_tasks
    @complete_tasks = @group.complete_tasks
    @tasks = @group.tasks

    @history = current_user.history
  end

  def remove_member
    membership = @group.memberships.where(:user_id => params[:user_id])
    @group.memberships.destroy(membership)
    redirect_to @group
  end

  private

  def authorized_user
    @group = Group.find(params[:id])
    redirect_to root_path unless current_user.groups.include? @group
  end
end
