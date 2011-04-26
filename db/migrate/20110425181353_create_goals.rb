class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.string :title
      t.string :description
      t.boolean :active, :default => false
      t.integer :user_id
      t.timestamps
    end
    add_index :goals, :user_id
    add_index :goals, :id
  end

  def self.down
    drop_table :goals
  end
end
