require 'spec_helper'

describe Task do

  before :each do
    @user = Factory :user
    @goal = Factory(:goal, :user => @user)
    @task = Factory(:task, :goal => @goal)
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

    it "should default to completed == nil" do
      @task.complete.should be_nil
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
      @task = Factory(:task, :goal => @goal)
    end
    it "uses Chronic to parse a common-language time" do
      @task.deadline_string = "in two weeks"
      @task.deadline_string.should == 2.weeks.from_now.to_s
      @task.should be_valid
    end

    it "parses a rigid datetime format" do
      @task.deadline_string = "2011-06-08 02:51:19 UTC"
      @task.deadline_string.should == "2011-06-08 02:51:19 UTC"
      @task.should be_valid
    end

    it "sets an error if the datetime is incomprehensible" do
      @task.deadline_string = "foobar"
      @task.should_not be_valid
    end
  end

  describe "task_type" do

  end
end
