class GoalsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy, :update]

  def new
    @title = "New Goal"
    @user = current_user
    @goal = @user.goals.new
  end


  def create
    @goal = current_user.goals.build params[:goal]
    if @goal.save
      flash[:success] = "Goal created!"
      redirect_to dashboard_path
    else
      render 'new'
    end
  end

  def index
    @title = "Dashboard"
    @goals = current_user.goals.all
    @goal_tasks = []
    @goals.each do |goal|
      @goal_tasks << [goal, goal.tasks.all]
    end
  end

  def edit
    @title = "Edit Goal"
    @goal = Goal.find params[:id]
  end

  def update
    @goal = Goal.find params[:id]
    if @goal.update_attributes params[:goal]
      flash[:success] = "Goal updated!"
      redirect_to dashboard_path
    else
      @title = "Edit Goal"
      render 'edit'
    end
  end

  def destroy
    @goal.destroy
    redirect_back_or dashboard_path
  end

  private

  def authorized_user
    @goal = Goal.find params[:id]
    redirect_to root_path unless current_user? @goal.user
  end
end