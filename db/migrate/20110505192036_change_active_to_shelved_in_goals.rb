class ChangeActiveToShelvedInGoals < ActiveRecord::Migration
  def self.up
    remove_column('goals', 'active')
    add_column('goals', 'shelved', :boolean, :default => false)
  end

  def self.down
    remove_column('goals', 'shelved')
    add_column('goals', 'active', :boolean, :default => false)
  end
end
