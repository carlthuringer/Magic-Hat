class AddTypeToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :kind, :string, :default => 'plain'
  end

  def self.down
    remove_column :tasks, :kind
  end
end
