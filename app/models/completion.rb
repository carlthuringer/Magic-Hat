class Completion < ActiveRecord::Base

  attr_accessible :created_at
  belongs_to :task

  def created_at=(time = Time.now)
    self.created_at = time
  end
end
