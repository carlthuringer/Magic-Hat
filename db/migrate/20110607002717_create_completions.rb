class CreateCompletions < ActiveRecord::Migration
  def self.up
    create_table :completions do |t|
      t.integer :task_id

      t.timestamps
    end
    add_index :completions, :task_id
  end

  def self.down
    drop_table :completions
    remove_index :completions, :task_id
  end
end
