class RemoveGoals < ActiveRecord::Migration
  def up
    remove_index :goals, :name => 'index_goals_on_id'
    remove_index :goals, :name => 'index_goals_on_user_id'
    drop_table :goals
  end

  def down
  end
end
