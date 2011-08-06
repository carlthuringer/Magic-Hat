class AddGroupForeignKeyToTask < ActiveRecord::Migration
  def up
    add_column :tasks, :group_id, :integer
    add_column :tasks, :user_id, :integer
    cx = ActiveRecord::Base.connection
    cx.execute('update tasks set user_id = goals.user_id from goals where goals.id = tasks.goal_id')
  end

  def down
    remove_column :tasks, :group_id
    remove_column :tasks, :user_id
  end

end
