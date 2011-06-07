class RemoveHabits < ActiveRecord::Migration
  def self.up
    drop_table :habits
    remove_column :tasks, :habit_id
    add_column :tasks, :schedule_yaml, :string
  end

  def self.down
    create_table :habits do |t|
      t.string :description
      t.string :schedule_yaml
      t.timestamps
      t.integer :task_id
      t.integer :goal_id
    end
    remove_column :tasks, :schedule_yaml
  end
end
