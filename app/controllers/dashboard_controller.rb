class DashboardController < ApplicationController
  before_filter :authenticate

  def index
    @body_class = "dashboard"
    @title = "Dashboard"
    @goals = current_user.active_goals
    @groups = current_user.groups
    @important_tasks = current_user.important_tasks
    @history = current_user.history
    @invitations = Invitation.where(:user_email => current_user.email)
    @task = current_user.tasks.build
  end
end
