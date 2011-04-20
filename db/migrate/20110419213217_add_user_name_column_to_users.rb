class AddUserNameColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column "users", "user_name", :text
  end

  def self.down
    remove_column "users", "user_name"
  end
end
