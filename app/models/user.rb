require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :time_zone

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Required before_validation to prevent empty form fields that aren't required from causing
  # a validation error.
  #before_validation :clear_empty_web_bio_attrs
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  # Automatically create the virtual attribute 'password confirmation'
  validates :password, :presence     => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password

  has_many :tasks
  has_many :group_tasks, :through => :groups, :source => :tasks
  has_many :completions, :through => :tasks, :dependent => :destroy

  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :invitations, :through => :groups

  # Return true if the user's submitted password matches the hashed one.
  def has_password?(submitted_password)
    # Compare encrypted password with the encrypted version of
    # Submitted password
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def active_goals
    goals.order("updated_at DESC")
  end

  def important_tasks
    (tasks + group_tasks).uniq.select{|task| task.incomplete_or_habit? }.sort{|a,b| b.updated_at <=> a.updated_at }
  end

  def important_group_tasks
    group_tasks.order("updated_at DESC").select {|task| task.incomplete_or_habit? }
  end


  def velocity
    three_week_total = completions.where(:time => (3.weeks.ago)..(Time.now)).count
    three_week_total / 3
  end

  def tasks_completed_today
    completions.where(:time => (1.day.ago)..(Time.now)).count
  end

  def empty_profile
    self.name.blank? && self.website.blank? && self.biography.blank?
  end

  def history
    history = Array.new(28, 0)
    completions.where(:time => (28.days.ago)..(Time.now)).each do |c|
      c_completed_days_ago = (Time.now.to_i - c.time.to_i) / 60 / 60 / 24
      history[c_completed_days_ago] = history[c_completed_days_ago] + 1
    end
    return history.reverse!
  end

  def invitations_addressed_to_me
    Invitation.where user_email: email
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
