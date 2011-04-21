class AddUserNameColumnToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.text :user_name
    end
  end

  def self.down
    remove_column "users", "user_name"
  end
end
