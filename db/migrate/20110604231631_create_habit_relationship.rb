class CreateHabitRelationship < ActiveRecord::Migration
  def self.up
    add_column :habits, :user_id, :integer
    add_column :habits, :task_id, :integer
  end

  def self.down
    remove_column :habits, :user_id
    remove_column :habits, :task_id
  end
end
