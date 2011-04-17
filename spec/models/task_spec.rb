require 'spec_helper'

describe Task do

  it "has a Plan association" do
    test_plan = FactoryGirl.build(:plan)
    test_task = FactoryGirl.build(:task)
    test_task.plan = test_plan
    test_task.plan.should == test_plan
  end
end
