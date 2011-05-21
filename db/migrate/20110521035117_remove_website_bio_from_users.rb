class RemoveWebsiteBioFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :website
    remove_column :users, :biography
  end

  def self.down
    add_column :users, :website, :string, :limit => 256
    add_column :users, :biography, :text
  end
end
