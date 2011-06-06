require 'spec_helper'

describe Habit do

  before :each do
    @user = Factory :user

    @habit = Factory :habit, :user => @user
  end
  describe "schedule_attributes" do

    before :each do
      @params = {:repeat => 1, :start_date => Time.now.to_s, :interval_unit => 'day',
        :interval => 2}
    end

    it "accepts parameters and saves them" do
      @habit.schedule_attributes = @params
      @habit.save
      @habit.reload
      @habit.schedule.should_not be_nil
    end

    it "has daily schedule when one is not set" do
      pending "This doesn't seem to work yet. Might dump it."
      @habit.save
      @habit.reload
      @habit.schedule.should == IceCube::Rule.daily
    end

    it "finds the next occurence" do
      @habit.schedule_attributes = @params
      @habit.schedule.next_occurrence.should === 2.days.since(Time.parse(@params[:start_date]))
    end
  end

  describe "relationships" do

    it "knows to which user it belongs" do
      pending "Might be irrelevant?"
      @habit.user_id.should == @user.id
    end

    it "knows to which goal it belongs" do
      # @habit.goal_id.should == 
    end

  end

  describe "tasks" do
    it "generates a task when it doesn't have one" do
      expect {
        @habit.generate
      }.to change(Task, :count).by 1
    end

    it "generates a new task when its current task is done" do
      pending "need to set up goal relationship"
      goal = Factory :goal, :user => @user
      task = Factory :task, :goal => goal, :habit => @habit
      @habit.task_id = task.id
      @habit.save

      expect {
        @habit.generate
      }.to change(Task, :count).by 1
    end
  end
end
