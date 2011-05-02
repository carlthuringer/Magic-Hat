class Task < ActiveRecord::Base
  attr_accessible :description, :complete

  validates :description, :presence => true,
    :length => { :minimum => 5 }

  belongs_to :goal

  def owned_by?(user)
    goal = Goal.find self.goal_id
    owner = User.find goal.user_id
    owner == user
  end

  def mark_complete
    self.complete = Time.now if self.complete == nil
    self.save
  end

  def clear_complete_time
    self.complete = nil
    self.save
  end

  def active?
    self.complete == nil
  end
end
