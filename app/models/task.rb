# == Schema Information
# Schema version: 20110502210408
#
# Table name: tasks
#
#  id          :integer         not null, primary key
#  description :string(255)
#  goal_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  complete    :datetime
#

class Task < ActiveRecord::Base
  attr_accessible :description, :complete, :deadline

  validates :description, :presence => true,
    :length => { :minimum => 5 }
  validate :deadline_string_no_errors

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

  def deadline_string
    self.deadline.to_s
  end

  def deadline_string=(deadline_str)
    unless deadline_str.blank?
      self.deadline = ( parse_time(deadline_str, Chronic) || parse_time(deadline_str, Time) )
      @deadline_invalid = true if self.deadline.nil?
    end
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


