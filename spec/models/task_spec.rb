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
  end

  describe "relationships" do

    it "should be one of a goal's tasks" do
      @goal.tasks.include?(@task)
    end
  end

end
