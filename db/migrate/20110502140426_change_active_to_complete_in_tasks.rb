class ChangeActiveToCompleteInTasks < ActiveRecord::Migration
  def self.up
    remove_column('tasks', 'active')
    add_column('tasks', 'complete', :datetime, :default => nil)
  end

  def self.down
    remove_column('tasks', 'complete')
    add_column('tasks', 'active')
  end
end
