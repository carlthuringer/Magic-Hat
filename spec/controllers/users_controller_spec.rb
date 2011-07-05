require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do

    before :each do
      @user = Factory :user
    end

    describe "displayed user is not signed in user or no user signed in" do

      before :each do
        get :show, :id => @user
      end

      it "should be successful" do
        response.should be_success
      end

      it "should find the right user" do
        assigns(:user).should == @user
      end

      it "should have the right title" do
        response.should have_selector("title", :content => @user.name)
      end

      it "should include the user's name" do
        response.should have_selector("h1", :content => @user.name)
      end

      it "should not have an edit link" do
        response.should_not have_selector('a', :href => edit_user_path(@user))
      end
    end

    describe "displayed user is signed in" do

      it "should have an edit link" do
        test_sign_in @user
        get :show, :id => @user
        response.should have_selector('a', :href => edit_user_path(@user))
      end

    end
  end

  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end

    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end

    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before :each do
        @attr = { :name => '', :email => '', :password => '', :password_confirmation => '' }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before :each do
        @attr = { :name => "New User", :email => "user@example.com", :password => "foobar",
                  :password_confirmation => "foobar" }
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the dashboard" do
        post :create, :user => @attr
        response.should redirect_to(dashboard_path)
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /account created/i
      end
    end
  end

  describe "GET 'edit'" do

    before :each do
      @user = Factory :user
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Edit user")
    end
  end

  describe "PUT 'edit'" do

    before :each do
      @user = Factory :user
      test_sign_in @user
    end

    describe "failure" do

      before :each do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should render the edit page" do
        put :update, :id => @user, :user => @attr
        response.should render_template 'edit'
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector('title', :content => "Edit user")
      end
    end

    describe "success" do

      before :each do
        @attr = { :name => "New Name", :email => "newemail@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to user_path @user
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end

  describe "authentication of edit/update pages" do

    before :each do
      @user = Factory :user
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to signin_path
      end

      it "should deny access to 'update'" do
        put :update, :id => @user
        response.should redirect_to signin_path
      end
    end

    describe "for signed-in users" do

      before :each do
        wrong_user = Factory(:user, :email => "wronguser@wakkawakka.co.jp")
        test_sign_in wrong_user
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to root_path
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to root_path
      end
    end
  end

  describe "DELETE 'destroy'" do

    before :each do
      @user = Factory :user
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to signin_path
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in @user
        delete :destroy, :id => @user
        response.should redirect_to root_path
      end
    end

    describe "as an admin user" do

      before :each do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in @admin
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by -1
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to users_path
      end

      it "should not allow the admin to destroy himself" do
        lambda do
          delete :destroy, :id => @admin
        end.should_not change(User, :count).by -1
      end
    end
  end
end
