class ChangeScheduleYamlToTypeText < ActiveRecord::Migration
  def up
    change_column :tasks, :schedule_yaml, :text
  end

  def down
    change_column :tasks, :schedule_yaml, :string
  end
end
