# == Schema Information
# Schema version: 20110604231631
#
# Table name: habits
#
#  id            :integer         not null, primary key
#  description   :string(255)
#  schedule_yaml :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#  task_id       :integer
#

class Habit < ActiveRecord::Base
  include ScheduleAttributes

  attr_accessible :description
  validates :description, :presence => true,
    :length => { :within => (4..40) }
  validates :schedule, :presence => true

  belongs_to :goal
  has_one :task

  def generate
    if task.try(:completed) != nil || task.nil?
      due_date = schedule.next_occurrence
      create_task(:description => description, :deadline => due_date)
    end
  end
end
