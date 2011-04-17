class Plan < ActiveRecord::Base
  validates_presence_of :description
  has_many :tasks
end
