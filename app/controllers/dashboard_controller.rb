class DashboardController < ApplicationController

  def index
    @title = "Dashboard"
    @goals = current_user.goals.all
    @goal_tasks = []
    @goals.each do |goal|
      @goal_tasks << [goal, goal.tasks.all]
    end
  end
end
