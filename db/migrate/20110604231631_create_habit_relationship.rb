class CreateHabitRelationship < ActiveRecord::Migration
  def self.up
    add_column :users, :habit_id, :integer
    add_column :habits, :user_id, :integer
   add_column :habits, :task_id, :integer
    add_column :tasks, :habit_id, :integer
  end

  def self.down
    remove_column :users, :habit_id
    remove_column :habits, :user_id
    remove_column :habits, :task_id
    remove_column :tasks, :habit_id
  end
end
