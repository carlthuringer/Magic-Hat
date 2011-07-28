class Membership < ActiveRecord::Base
  set_table_name :memberships

  belongs_to :user
  belongs_to :group

end
