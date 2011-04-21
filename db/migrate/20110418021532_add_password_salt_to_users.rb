class AddPasswordSaltToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.text :password_salt
    end
  end

  def self.down
    remove_column "users", "password_salt"
  end
end
