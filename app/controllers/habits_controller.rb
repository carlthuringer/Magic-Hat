class HabitsController < ApplicationController
  before_filter :authenticate

  def index
    @habits = current_user.habits
    @title = "Habits"
  end

  def new
    @title = "New Habit"
    @habit = Habit.new
  end

  def create
    @habit = current_user.habits.build params[:habit]
    if @habit.save
      flash[:success] = "Habit created!"
      redirect_to dashboard_path
    else
      render 'new'
    end
  end
end
