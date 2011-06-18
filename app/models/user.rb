# == Schema Information
# Schema version: 20110604231631
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#  created_at         :datetime
#  updated_at         :datetime
#  habit_id           :integer
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password

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

  has_many :goals, :dependent => :destroy
  has_many :tasks, :through => :goals, :dependent => :destroy
  has_many :completions, :through => :tasks, :dependent => :destroy

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
    goals.where(:shelved => false).order("updated_at DESC")
  end

  def shelved_goals
    goals.where(:shelved => true).order("updated_at DESC")
  end

  def important_tasks
    tasks.order("deadline DESC").select {|task| task.incomplete_or_habit? }
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
    # TODO Check for a way to avoid doing /60/60/24
    completions.where(:time => (28.days.ago)..(Time.now)).each do |c|
      c_completed_days_ago = (Time.now.to_i - c.time.to_i) / 60 / 60 / 24 - 1
      history[c_completed_days_ago] = history[c_completed_days_ago] + 1
    end
    return history
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
