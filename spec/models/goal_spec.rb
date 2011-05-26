require 'spec_helper'

describe Goal do
  before :each do
    @attr = {
      :title => "Spec Goal Title",
      :description => "Spec Goal Description"
    }
  end

  it "should create a new goal given valid attributes" do
    Goal.create!(@attr)
  end

  it "should require a title" do
    goal = Goal.new(@attr.merge(:title => ""))
    goal.should_not be_valid
  end

  it "should reject a title that is too long" do
    goal = Goal.new(@attr.merge(:title => "a" * 41))
    goal.should_not be_valid
  end

  it "should require a description" do
    goal = Goal.new(@attr.merge(:description => ""))
    goal.should_not be_valid
  end

  it "Should default to 'shelved' = false" do
    goal = Goal.new(@attr)
    goal.shelved.should be_false
  end

end
