class Plan < ActiveRecord::Base
  validates_presence_of :description
end
