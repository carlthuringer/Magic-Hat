class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.text :description
      t.date :due_date
      t.boolean :completed

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
