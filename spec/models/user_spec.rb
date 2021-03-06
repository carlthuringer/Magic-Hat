require 'spec_helper'

describe User do
  before :each do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobars",
      :password_confirmation => "foobars",
    }
  end

  it "should create a new user instance given valid attributes" do
    User.create!(@attr)
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

  describe "Statistics" do

    before :each do
      @user = Factory :user
      @tasks = []
      5.times do
        @tasks << Factory(:task, :user => @user)
      end

      @tasks[0..1].each do |task|
        task.mark_complete
      end

      @tasks[3..4].each do |task|
        task.mark_complete(1.week.ago)
        task.save
      end
    end

    it "should have a velocity method" do
      @user.should respond_to :velocity
    end

    it "should report 2 tasks completed today" do
      @user.tasks_completed_today.should == 2
    end

    it "should calculate a rounded velocity average based on tasks per week, versus the past three weeks." do
      5.times do
        @tasks << Factory(:task, :user => @user)
      end

      @tasks.each do |task|
        task.mark_complete(2.weeks.ago)
        task.save
      end

      @user.velocity.should == 4
    end

    describe "history" do

      it "should return a marked calendar array" do
        20.times do
          task = Factory(:task)
          task.mark_complete(rand(28).days.ago)
        end

        @user.history.size.should == 28
        @user.history.include?(1)
      end
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => '')).should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long)
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

  describe "task associations" do

    before :each do
      @user = Factory :user
      @task = Factory(:task, :user => @user)
    end

    it "should discover its own tasks through its association" do
      @user.tasks.first.should == @task
    end
  end

  describe "completion associations" do

    before :each do
      @user = Factory :user
      @task = Factory :task, :user => @user
      @task.mark_complete
    end

    it "should discover its completions through its association" do
      @user.completions.first.task_id.should == @task.id
    end
  end

  describe "#important_tasks" do

    before :each do
      @user = Factory :user
    end

    it "should respond with a list of tasks that have no completions" do
      5.times { Factory :task }
      @user.important_tasks.each do |task|
        task.completions.should be_empty
      end
    end

    it "should not show the task with a completion" do
      @task = Factory :task
      @task.mark_complete
      @user.reload
      @user.important_tasks.should be_empty
    end

    it "should not show the habit with a completion" do
      @habit = Factory :task
      @habit.mark_complete
      @user.reload
      @user.important_tasks.should be_empty
    end

    it "should show the habit when its completion is old" do
      @habit = Factory :task, :user => @user
      @habit.mark_complete
      @habit.toggle_habit
      @user.reload
      Timecop.freeze(Date.today + 3) do
        @user.important_tasks.should_not be_empty
      end
    end
  end
end
