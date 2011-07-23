# The group model has tasks. It has and belongs to many users.

class Group < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :users
  validates_presence_of :name

end
