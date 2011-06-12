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
    @task.description = params[:task][:description]
    @task.deadline_string=params[:task][:deadline_string]
    if params[:task][:repeat] == "1"
      @task.schedule_attributes = params[:task][:schedule_attributes]
    end
    if @task.save
      redirect_to dashboard_path
    else
      @title = "Edit Task"
      render :edit
    end
  end

  def complete
    current_user.tasks.each do |task|
      # Because the array of task IDs is returned as a string and we're
      # doing an include? to compare that array's items against an integer
      # id we have to convert the task ID to a string or else it won't match.
      if params[:ids]
        unless params[:ids].include?(task.id.to_s)
          task.clear_complete
        end
      else
        task.clear_complete
      end
    end
    if params[:ids]
      Task.find(params[:ids]).each do |task|
        task.mark_complete
      end
    end

    redirect_to dashboard_path
  end

  def complete_toggle
    @task = Task.find params[:id]
    if @task.complete == nil
      @task.mark_complete
    else
      @task.clear_complete
    end
    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.js
    end
  end

  def destroy
    @task = Task.find params[:id]
    @task.destroy
    redirect_to dashboard_path
  end

  private

  def authorized_user
    if params[:ids]
      params[:ids].each do |id|
        task = Task.find id
        redirect_back_or dashboard_path unless task.owned_by? current_user
      end
    elsif params[:id]
      task = Task.find params[:id]
      redirect_back_or dashboard_path unless task.owned_by? current_user
    end
  end
 end
