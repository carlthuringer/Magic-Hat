require 'spec_helper'

describe "LayoutLinks" do

  it "should have a home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end

  it "should have a home link" do
    get '/'
    response.should have_selector('a', :href => root_path)
  end

  describe "when not signed in" do
    
    it "should have a signin link" do
      visit root_path
      response.should have_selector('a', :href => signin_path,
                                         :content => "Sign in")
    end
  end

  describe "when signed in" do

    before :each do
      @user = Factory :user
      visit signin_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector('a', :href => signout_path,
                                         :content => "Sign out")
    end

    it "should have a dashboard link" do
      visit root_path
      response.should have_selector('a', :href => dashboard_path,
                                    :content => "Dashboard")
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector('a', :href => edit_user_path(@user))
    end
  end
end
