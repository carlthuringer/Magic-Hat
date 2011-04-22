class AddTitleFieldToPlans < ActiveRecord::Migration
  def self.up
    change_table :plans do |t|
      t.text :title
    end
  end

  def self.down
    remove_column :plans, :title
  end
end
