require 'spec_helper'

describe Completion do

  describe "relationship" do

    it "knows to which task it belongs" do
      task = Factory :task
      completion = Completion.new(:task_id => task.id)
      completion.task.should == task
    end
  end
end
