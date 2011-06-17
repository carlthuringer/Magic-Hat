class Completion < ActiveRecord::Base

  attr_accessible :time
  belongs_to :task

end
