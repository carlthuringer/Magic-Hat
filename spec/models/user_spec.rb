require 'spec_helper'

describe User do
  before :each do
    @user = User.new(:user_name => "Foo Bar", :email => "foo@bar.com", :password => "eighteen", :password_confirmation => "eighteen")
  end
  
  it "Should not allow new users with a password shorter than 8 characters." do
    @user.password, @user.password_confirmation = "1234567"
    @user.save.should == false
  end

  it "Should require a User Name during registration." do
    @user.user_name = nil
    @user.save.should == false
  end
  
end

# User Schema Reference
# create_table "users", :force => true do |t|
#   t.string   "email",                                 :default => "", :null => false
#   t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
#   t.string   "reset_password_token"
#   t.datetime "reset_password_sent_at"
#   t.datetime "remember_created_at"
#   t.integer  "sign_in_count",                         :default => 0
#   t.datetime "current_sign_in_at"
#   t.datetime "last_sign_in_at"
#   t.string   "current_sign_in_ip"
#   t.string   "last_sign_in_ip"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.text     "password_salt"
# end


