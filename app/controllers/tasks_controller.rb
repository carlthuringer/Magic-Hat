class TasksController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :except => :create

  def new
    @title = "New Task"
    @goal = Goal.find params[:goal_id]
    @task = @goal.tasks.build(:goal_id => @goal.id)
  end

  def create
    @goal = Goal.find params[:task][:goal_id]
    @task = @goal.tasks.build params[:task]
    if @task.save
      redirect_to dashboard_path
    else
      @title = "New Task"
      render :new
    end
  end

  def edit
    @title = "Edit Task"
    @task = Task.find params[:id]
    @goal = Goal.find @task.goal_id
  end

  def update
    @task = Task.find params[:id]
    @goal = Goal.find @task.goal_id
    if @task.update_attributes params[:task]
      flash[:success] = "Task updated!"
      redirect_to dashboard_path
    else
      @title = "Edit Task"
      render :edit
    end
  end

  def destroy
    @task = Task.find params[:id]
    @task.destroy
    redirect_to dashboard_path
  end

  private

  def authorized_user
    # Depending on the method, the task :id may be set, or the :goal_id may be set.
    # Find out which one is set and use that as a basis for discovering whether
    # the current user is authorized to act upon this Task.
    if params[:goal_id]
      goal = Goal.find params[:goal_id]
    elsif params[:id]
      task = Task.find params[:id]
      goal = Goal.find task.goal_id
    else
      redirect_to root_path
    end
    owner = User.find goal.user_id

    redirect_back_or dashboard_path unless owner == current_user

  end
end
