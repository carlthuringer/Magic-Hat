class DashboardController < ApplicationController
  before_filter :authenticate

  def index
    @title = "Dashboard"
    @goals = current_user.goals.all
  end
end
