require 'spec_helper'

describe Plan do
  it "doesn't allow a Plan with no description" do
    test_plan = FactoryGirl.build(:plan, :description => nil)
    test_plan.save.should == false
  end
end
