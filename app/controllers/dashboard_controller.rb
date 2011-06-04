class DashboardController < ApplicationController
  before_filter :authenticate

  def index
    @body_class = "dashboard"
    @title = "Dashboard"
    @goals = current_user.active_goals
    @important_tasks = current_user.important_tasks
    @total_completed = current_user.tasks_completed_today
    @velocity = current_user.velocity
    @history = current_user.history
  end

  def shelved
    @body_class = "shelved"
    @title = "Dashboard"
    @goals = current_user.shelved_goals
    @total_completed = current_user.tasks_completed_today
    @velocity = current_user.velocity
    @shelf_verb = "Unshelve"
    render :index
  end

end
