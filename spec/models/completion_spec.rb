require 'spec_helper'

describe Completion do

  describe "relationship" do

    it "knows to which task it belongs" do
      task = Factory :task
      completion = task.completions.build
      completion.task.should == task
    end
  end
end
