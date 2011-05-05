class AddProfileFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :website, :string, :limit => 256
    add_column :users, :biography, :text
  end

  def self.down
    remove_column :users, :biography
    remove_column :users, :website
  end
end
