require 'spec_helper'

describe Habit do

  describe "schedule_attributes" do

    before :each do
      @params = {:repeat => 1, :start_date => Time.now.to_s, :interval_unit => 'day',
        :interval => 2}
      @habit = Habit.new(:description => "Test habit with this")
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
end
