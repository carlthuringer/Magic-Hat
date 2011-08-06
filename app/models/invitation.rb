class Invitation < ActiveRecord::Base
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :user_email, :presence   => true,
                    :format     => { :with => EMAIL_REGEX }

  belongs_to :group

end
