class HabitsController < ApplicationController
  before_filter :authenticate

  def index
    @habits = current_user.habits
    @title = "Habits"
  end
end
