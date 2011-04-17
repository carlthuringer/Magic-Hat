require 'spec_helper'

describe Plan do
  pending "add some examples to (or delete) #{__FILE__}"

  it "doesn't allow a Plan with no description" do
    test_plan = Plan.new(:due_date => "12-25-2012")
    test_plan.save.should == false
  end
end
