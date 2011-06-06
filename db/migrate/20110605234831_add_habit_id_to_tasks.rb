class AddHabitIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :habit_id, :integer
  end

  def self.down
    remove_column :tasks, :habit_id
  end
end
