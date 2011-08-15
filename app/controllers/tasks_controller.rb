class TasksController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :except => :create

  def new
    @title = "New Task"
    @group_id = params[:group_id]
    @task = current_user.tasks.build group_id: @group_id
  end

  def create
    @task = current_user.tasks.build params[:task]

    if @task.save
      redirect_to root_path
    else
      @title = "New Task"
      render :new
    end
  end

  def edit
    @title = "Edit Task"
    @task = Task.find params[:id]
    @task.start_date ||= Date.today
    @task.interval_unit = 'week'
    @task.interval = 1
  end

  def update
    @task = Task.find params[:id]

    wipe_schedule_yaml

    if @task.update_attributes(params[:task])
      flash[:success] = "Task Updated!"
      redirect_to root_path
    else
      @title = "Edit Task"
      render :edit
    end
  end

  def complete_toggle
    @task = Task.find params[:id]
    if @task.incomplete_or_habit?
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
  def wipe_schedule_yaml
    if params[:task][:schedule_attributes]
      if params[:task][:schedule_attributes][:repeat] == "0"
        params[:task].delete(:schedule_attributes)
        @task.schedule_yaml = nil
        @task.save!
      end
    end
  end
end

