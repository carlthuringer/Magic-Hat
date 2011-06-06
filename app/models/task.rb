# == Schema Information
# Schema version: 20110604231631
#
# Table name: tasks
#
#  id          :integer         not null, primary key
#  description :string(255)
#  goal_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  complete    :datetime
#  deadline    :datetime
#  kind        :string(255)     default("plain")
#  habit_id    :integer
#

class Task < ActiveRecord::Base
  attr_accessible :description, :complete, :deadline, :type

  validates :description, :presence => true,
    :length => { :minimum => 5 }
  validate :deadline_string_no_errors

  belongs_to :goal
  belongs_to :habit

  def owned_by?(user)
    goal = Goal.find self.goal_id
    owner = User.find goal.user_id
    owner == user
  end

  def mark_complete
    self.complete = Time.now if self.complete == nil
    self.save
  end

  def clear_complete
    self.complete = nil
    self.save
  end

  def active?
    self.complete == nil
  end

  def deadline_string
    self.deadline.to_s
  end

  def deadline_string=(deadline_str)
    unless deadline_str.blank?
      self.deadline = ( parse_time(deadline_str, Chronic) || parse_time(deadline_str, Time) )
      @deadline_invalid = true if self.deadline.nil?
    end
  end

  def make_habit(schedule)
    create_habit(:description => description, :goal => task.goal)
  end

  private

  def parse_time(string, parser)
    begin
      parser.parse(string)
    rescue
    end
  end

  def deadline_string_no_errors
    errors.add(:deadline_string, "Is Invalid") if @deadline_invalid
  end

end


