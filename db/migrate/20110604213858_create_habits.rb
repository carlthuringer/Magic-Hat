class CreateHabits < ActiveRecord::Migration
  def self.up
    create_table :habits do |t|
      t.string :description
      t.string :schedule_yaml

      t.timestamps
    end
  end

  def self.down
    drop_table :habits
  end
end
