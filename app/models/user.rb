# == Schema Information
# Schema version: 20110502210408
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
#  website            :string(256)
#  biography          :text(1400)
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :website, :biography

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  website_regex = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix

  # Required before_validation to prevent empty form fields that aren't required from causing
  # a validation error.
  #before_validation :clear_empty_web_bio_attrs
  validates :name, :presence => true,
                   :length   => { :maximum => 50}
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  # Automatically create the virtual attribute 'password confirmation'
  validates :password, :presence     => true,
                       :length       => { :within => 6..40 }
  validates :website, :format => { :with => website_regex, :allow_blank => true}
  validates :biography, :length => { :within => 10..1400, :allow_blank => true }

  before_save :encrypt_password

  has_many :goals, :dependent => :destroy
  has_many :tasks, :through => :goals

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

  def velocity
    three_week_total = tasks.where(:complete => (3.weeks.ago)..(Time.now)).count
    three_week_total / 3
  end

  def tasks_completed_today
    tasks.where(:complete => (1.day.ago)..(Time.now)).count
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

  protected

  def clear_empty_web_bio_attrs
    # This is required so that when integration tests submit a form with an empty field
    # it doesn't complain about the "" value being invalid.
    self.website = nil if self.website.blank?
    self.biography = nil if self.website.blank?
  end
end
