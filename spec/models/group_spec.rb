require 'spec_helper'

describe Group do

  # The only methods in Group are one-line queries...
  # How do I test these without Factory-ing up a lot of tasks?

  it "returns a collection of incomplete tasks sorted by deadline" do
    pending "Barking up the wrong tree...?"
    task1, task2, task3 = [1, 3, 2].map { |a| Date.today + a }
    task_collection = [task1, task2, task3]
    group = Group.new
    group.stub(:tasks).and_return(task_collection)
    group.incomplete_tasks.should == task_collection
  end
end
