# == Schema Information
# Schema version: 20110604192102
#
# Table name: goals
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  shelved     :boolean
#

class Goal < ActiveRecord::Base
  attr_accessible :title, :description, :shelved

  validates :title, :presence => true,
    :length => { :within => (4..40) }
  validates :description, :presence => true

  belongs_to :user

  has_many :tasks
  has_many :habits

  def owned_by?(user)
    owner = User.find self.user_id
    owner == user
  end

  def incomplete_tasks
    result = tasks.order(["deadline ASC", "updated_at DESC"])
    result = tasks.select {|task| task.incomplete_or_habit?}
  end

  def complete_tasks
    tasks.where("complete IS NOT NULL").order("complete DESC")
  end
end
