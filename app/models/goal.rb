class Goal < ActiveRecord::Base
  attr_accessible :title, :description

  validates :title, :presence => true,
    :length => { :within => (4..40) }
  validates :description, :presence => true

  belongs_to :user

  has_many :tasks

  def owned_by?(user)
    owner = User.find self.user_id
    owner == user
  end

  def recent
    order("updated_at DESC")
  end

  def incomplete_tasks
    self.tasks.find :all, :order => "updated_at DESC", :conditions => [ "complete IS NULL" ]
  end

  def complete_tasks
    self.tasks.find :all, :order => "complete DESC", :conditions => [ "complete IS NOT NULL" ]
  end
end
