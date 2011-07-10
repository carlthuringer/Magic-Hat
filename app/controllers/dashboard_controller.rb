class DashboardController < ApplicationController
  before_filter :authenticate

  def index
    @body_class = "dashboard"
    @title = "Dashboard"
    @goals = current_user.active_goals
    @important_tasks = current_user.important_tasks
    @history = current_user.history
  end
end
