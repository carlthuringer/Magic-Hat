# The group model has tasks. It has and belongs to many users.

class Group < ActiveRecord::Base
  attr_accessible :name

  has_many :memberships
  has_many :users, :through => :memberships

  validates_presence_of :name

end
