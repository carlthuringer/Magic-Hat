class Goal < ActiveRecord::Base
  attr_accessible :title, :description

  validates :title, :presence => true,
    :length => { :within => (4..40) }
  validates :description, :presence => true

  belongs_to :user
end
