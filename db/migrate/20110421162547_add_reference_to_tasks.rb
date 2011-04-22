class AddReferenceToTasks < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.integer :plan_id
    end
  end

  def self.down
    remove_column :tasks, :plan_id
  end
end
