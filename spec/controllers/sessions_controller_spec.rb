require 'spec_helper'

describe SessionsController do

  describe "#new" do

    it "should set the title" do
      get :new
      assigns(:title).should_not be_blank
    end

    it "should be successful" do
      get :new
      response.should be_success
    end
  end

  describe "successful #create" do

    before do
      @user = mock(User).as_null_object
      User.stub(:authenticate).and_return(@user)
      @user.stub(:nil?).and_return(false)
    end

    it "Delegates authentication to the User model" do
      auth_params = { 'email' => 'foo',
                      'password' => 'bar'}
      User.should_receive(:authenticate).with('foo', 'bar')
      post :create, :session => auth_params
    end

    it "signs in the user" do
      controller.should_receive(:sign_in).with(@user)
      post :create, :session => {}
    end

    it "redirects to the dashboard" do
      post :create, :session => {}
      response.should redirect_to dashboard_path
    end
  end

  describe "failed #create" do

    before do
      @user = mock(User).as_null_object
      User.stub(:authenticate).and_return(@user)
      @user.stub(:nil?).and_return(true)
    end

    it "sets a flash message" do
      post :create, :session => {}
      flash[:error].should_not be_empty
    end

    it "sets the title" do
      post :create, :session => {}
      assigns(:title).should_not be_empty
    end

    it "renders the new user template" do
      post :create, :session => {}
      response.should render_template :new
    end
  end

  describe "#destroy" do

    it "should sign the user out" do
      controller.should_receive(:sign_out)
      delete :destroy, :id => 1
    end

    it "redirects to the root path" do
      delete :destroy, :id => 1
      response.should redirect_to root_path
    end
  end
end
