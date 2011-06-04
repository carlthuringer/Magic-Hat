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
end
