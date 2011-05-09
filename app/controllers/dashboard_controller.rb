class DashboardController < ApplicationController
  before_filter :authenticate

  def index
    @body_class = "dashboard"
    @title = "Dashboard"
    @goals = current_user.active_goals
    @total_completed = current_user.tasks_completed_today
    @velocity = current_user.velocity
    @shelf_verb = "Shelve"
  end

  def shelved
    @body_class = "shelved"
    @title = "Dashboard"
    @goals = current_user.shelved_goals
    @shelf_verb = "Unshelve"
    render :index
  end

end
