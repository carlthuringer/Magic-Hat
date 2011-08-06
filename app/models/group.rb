# The group model has tasks. It has and belongs to many users.

class Group < ActiveRecord::Base
  attr_accessible :name

  has_many :memberships
  has_many :users, :through => :memberships
  has_many :invitations
  has_many :tasks

  validates_presence_of :name

  def incomplete_tasks
    tasks.order(["deadline ASC", "updated_at DESC"]).select {|task| task.incomplete_or_habit?}
  end

  def complete_tasks
    # This is a potential bottleneck in the future
    # See 'squeel' gem for a possible solution
    tasks.order(["deadline DESC", "updated_at DESC"]).select { |task| not task.incomplete_or_habit? }
  end
end
