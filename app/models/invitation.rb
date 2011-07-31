class Invitation < ActiveRecord::Base
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence   => true,
                    :format     => { :with => email_regex }

  belongs_to :group

end
