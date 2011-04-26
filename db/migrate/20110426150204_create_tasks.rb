class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :description
      t.boolean :active, :default => false
      t.integer :goal_id

      t.timestamps
    end
    add_index :tasks, :goal_id
  end

  def self.down
    drop_table :tasks
  end
end
