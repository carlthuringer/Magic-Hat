class GoalsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy, :update]

  def new
    @title = "New Goal"
    @user = current_user
    @goal = @user.goals.new
    @header_back = { :title => "Back", :url => dashboard_path }
  end


  def create
    @goal = current_user.goals.build params[:goal]
    if @goal.save
      flash[:success] = "Goal created!"
      redirect_to @goal
    else
      render 'new'
    end
  end

  def show
    @goal = Goal.find params[:id]
    @goals = current_user.active_goals
    @history = current_user.history
    @title = @goal.title
    @tasks = @goal.tasks
    @incomplete_tasks = @goal.incomplete_tasks
    @complete_tasks = @goal.complete_tasks
  end

  def edit
    @title = "Edit Goal"
    @goal = Goal.find params[:id]
  end

  def update
    @goal = Goal.find params[:id]
    if @goal.update_attributes params[:goal]
      flash[:success] = "Goal updated!"
      redirect_to @goal
    else
      @title = "Edit Goal"
      render 'edit'
    end
  end

  def destroy
    @goal = Goal.find params[:id]
    @goal.destroy
    redirect_back_or dashboard_path
  end

  private

  def authorized_user
    goal = Goal.find params[:id]
    redirect_to root_path unless goal.owned_by? current_user
  end
end
