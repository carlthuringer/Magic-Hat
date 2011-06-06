class RemoveUserIdFromHabits < ActiveRecord::Migration
  def self.up
    remove_column :habits, :user_id
  end

  def self.down
    add_column :habits, :user_id, :integer
  end
end
