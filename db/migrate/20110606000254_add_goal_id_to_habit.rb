class AddGoalIdToHabit < ActiveRecord::Migration
  def self.up
    add_column :habits, :goal_id, :integer
  end

  def self.down
    remove_column :habits, :goal_id
  end
end
