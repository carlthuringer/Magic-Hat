class Task < ActiveRecord::Base
  attr_accessible :description
  
  validates :description, :presence => true,
    :length => { :minimum => 5 }

  belongs_to :goal
end
