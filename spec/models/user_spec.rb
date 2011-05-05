require 'spec_helper'

describe User do
  before :each do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobars",
      :password_confirmation => "foobars",
      :website => "http://www.google.com",
      :biography => "Just a few fake words about me."
    }
  end

  it "should create a new user instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ''))
    no_name_user.should_not be_valid
  end

  it "should reject a name that is too long" do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject email addresses that are invalid" do
    addresses = %w{user@foo,com THE_USERatfoo.bar.org first.last@foo.}
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with a given email address into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical when case is not considered" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject a Website that is in an invalid format" do
    bad_websites = ["Htp googlecom", "nanobar", "http://www.magichat.com/index.html?<funnybusiness>badstuff"]
    bad_websites.each do |badsite|
      user_with_bad_site = User.new(@attr.merge(:website => bad_websites[0]))
      user_with_bad_site.should_not be_valid
    end
  end

  it "should reject a bio that is too long" do
    long_bio = "a" * 2000
    user_with_long_bio = User.new(@attr.merge(:biography => long_bio))
    user_with_long_bio.should_not be_valid
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => '', :password_confirmation => "" )).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid" )).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short )
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long )
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do

    before :each do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistant_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistant_user.should be_nil
      end

      it "should return the user on an email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end

  describe "admin attribute" do

    before :each do
      @user = User.create! @attr
    end

    it "should respond to admin" do
      @user.should respond_to :admin
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertable to an admin" do
      @user.toggle! :admin
      @user.should be_admin
    end
  end

  describe "goal associations" do

    before :each do
      @user = User.create! @attr
      @goal1 = Factory(:goal, :user => @user)
      @goal2 = Factory(:goal, :user => @user)
      @goal3 = Factory(:goal, :user => @user)
      @goal4 = Factory(:goal, :user => @user, :shelved => true)
      @goal5 = Factory(:goal, :user => @user, :shelved => true)
    end

    it "should have a goals attribute" do
      @user.should respond_to :goals
    end

    it "should destroy associated goals" do
      @user.destroy
      [@goal1, @goal2].each do |goal|
        Goal.find_by_id(goal.id).should be_nil
      end
    end

    it "should respond with active goals, newest to oldest" do
      active_goals = @user.active_goals
      active_goals[0].should == @goal3
      active_goals.include?(@goal4).should_not be_true
    end

    it "should respond with shelved goals, newest to oldest" do
      shelved_goals = @user.shelved_goals
      shelved_goals[0].should == @goal5
      shelved_goals.include?(@goal2).should_not be_true
    end
  end
end
