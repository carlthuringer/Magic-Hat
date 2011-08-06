require 'spec_helper'

describe Task do

  before :each do
    @user = Factory :user
    @goal = Factory(:goal, :user => @user)
    @task = Factory(:task, :user => @user)
  end

  it "should create a new instance given valid attributes" do
    @task.save!
  end

  describe "validations" do

    it "should require a description" do
      @task.description = ""
      @task.should_not be_valid
    end

    it "should reject descriptions that are too short" do
      @task.description = "abcd"
      @task.should_not be_valid
    end

    it "should default to deadline == nil" do
      @task.deadline.should be_nil
    end
  end

  describe "relationships" do

    it "should be one of a goal's tasks" do
      @goal.tasks.include?(@task)
    end
  end

  describe "deadline_string" do

    before :each do
      @task = Factory(:task, :user => @user)
    end
    it "uses Chronic to parse a common-language time" do
      @task.deadline_string = "in two weeks"
      @task.deadline_string.should == 2.weeks.from_now.to_s
      @task.should be_valid
    end

    it "parses a rigid datetime format" do
      @task.deadline_string = "2011-06-08 02:51:19 -0500"
      @task.deadline_string.should == "2011-06-08 02:51:19 -0500"
      @task.should be_valid
    end

    it "sets an error if the datetime is incomprehensible" do
      @task.deadline_string = "foobar"
      @task.should_not be_valid
    end
  end

  describe "completion" do

    it "is able to record completion" do
      expect {
        @task.mark_complete
      }.to change(Completion, :count).by 1
    end

    it "is able to clear completion" do
      @task.mark_complete
      expect {
        @task.clear_complete
      }.to change(Completion, :count).by -1
    end

    it "is able to record multiple completions" do
      expect {
        2.times{ @task.mark_complete }
      }.to change(Completion, :count).by 2
    end
  end

  describe "habit" do

    it "can be converted into a habit" do
      @task.toggle_habit
      @task.reload
      @task.should be_habit
    end

    it "has no schedule by default" do
      @task.should_not be_habit
    end
  end

  describe "#incomplete_or_habit" do

    it "returns true if the habit has no completions" do
      @task.toggle_habit
      @task.reload
      @task.should be_incomplete_or_habit
    end

    it "returns false if the habit has a recent completion" do
      @task.toggle_habit
      @task.completions.create!
      @task.reload
      @task.should_not be_incomplete_or_habit
    end
  end
end
