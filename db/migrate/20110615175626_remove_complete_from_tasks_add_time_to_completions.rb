class RemoveCompleteFromTasksAddTimeToCompletions < ActiveRecord::Migration
  def up
    remove_column :tasks, :complete
    add_column :completions, :time, :datetime
  end

  def down
    remove_column :completions, :time
    add_column :tasks, :complete, :datetime
  end
end
