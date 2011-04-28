class Task < ActiveRecord::Base
  attr_accessible :description, :active

  validates :description, :presence => true,
    :length => { :minimum => 5 }

  belongs_to :goal
end
