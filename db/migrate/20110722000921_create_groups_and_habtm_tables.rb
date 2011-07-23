class CreateGroupsAndHabtmTables < ActiveRecord::Migration
  def change
    create_table :groups do |g|
      g.string :name
      g.timestamps
      g.boolean :default
    end

    create_table :groups_users, :id => false do |ug|
      ug.integer :group_id
      ug.integer :user_id
    end
  end
end
