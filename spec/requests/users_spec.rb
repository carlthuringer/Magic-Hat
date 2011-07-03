require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Email", :with => ""
          fill_in "Password", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div.error")
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Email", :with => "user@example.com"
          fill_in "Password", :with => "foobar"
          click_button
          response.should have_selector(".flash > .success",
                                        :content => "Created")
          response.should render_template("dashboard/index")
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in/out" do

    describe "failure" do

      it "should not sign a user in" do
        visit signin_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("ul.flash >.error", :content => "Invalid")
      end
    end

    describe "success" do

      it "should sign a user in and out" do
        pending "Need to provide a signout mechanism"
        user = Factory :user
        visit signin_path
        fill_in :email, :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end

  describe "edit" do
    before :each do
      user = Factory :user
      visit signin_path
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      click_button
    end

    describe "failure" do
    end
  end
end
