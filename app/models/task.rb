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
  include ScheduleAttributes

  attr_accessible :description, :complete, :deadline, :schedule_yaml

  validates :description, :presence => true,
    :length => { :minimum => 5 }
  validate :deadline_string_no_errors

  belongs_to :goal
  has_many :completions

  def owned_by?(user)
    goal = Goal.find self.goal_id
    owner = User.find goal.user_id
    owner == user
  end

  def mark_complete(time = Time.now)
    # self.complete = time if self.complete == nil
    # self.save
    self.completions.create
  end

  def clear_complete
    self.complete = nil
    self.save
    self.completions.last.destroy if self.completions.size > 0
  end

  def active?
    # self.complete == nil
    self.completions.empty? && self.schedule_yaml.nil?
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

  def toggle_habit
    if not habit?
      self.schedule_attributes = { :repeat => 1, :start_date => Time.now.to_s,
        :interval_unit => 'day', :interval => '2' }
      self.save
    else
      self.schedule_attributes = { :repeat => '0' }
      self.save
    end
  end

  def habit?
    schedule_yaml?
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


