require 'spec_helper'

describe UsersController do

  context "for unauthenticated users" do

    before do
      controller.stub(:authenticate).and_return(false)
    end

    context "who are unauthorized" do

      before do
        User.stub(:find).and_return( @found_user = mock(User).as_null_object)
        controller.stub(:current_user?).and_return(false)
      end

      describe "#new" do

        it "Instantiates a user" do
          User.should_receive(:new)
          get :new
        end

        it "assigns user" do
          User.stub(:new).and_return(user = mock(User))
          get :new
          assigns(:user).should == user
        end
      end

      describe "Successful #create" do

        before do
          @atts = {"foo" => "bar"}
          User.stub(:new).and_return(@user = mock(User).as_null_object)
        end

        it "Instantiates a user with the parameters" do
          User.should_receive(:new).with(@atts)
          post :create, :user => @atts
        end

        it "saves the user" do
          @user.should_receive(:save)
          post :create, :user => @atts
        end

        it "signs the user in" do
          controller.should_receive(:sign_in).with(@user)
          post :create, :user => @atts
        end

        it "sets the flash message" do
          post :create, :user => @atts
          flash[:success].should_not be_empty
        end

        it "redirects to the dashboard" do
          post :create, :user => @atts
          response.should redirect_to dashboard_path
        end
      end

      describe "failed #create" do

        before do
          @atts = {"foo" => "bar"}
          User.stub(:new).and_return(@user = mock(User).as_null_object)
          @user.stub(:save).and_return(false)
        end

        it "assigns the title" do
          post :create, :user => @atts
          assigns(:title).should_not be_empty
        end

        it "blanks the password if any" do
          #XXX This is probably not a valid test...
          @user.should_receive(:password=).with('')
          post :create, :user => @atts
        end

        it "renders the new user template" do
          post :create, :user => @atts
          response.should render_template :new
        end
      end

      describe "#edit" do

        it "redirects to the dashboard" do
          get :edit, :id => 1
          response.should redirect_to root_path
        end
      end

      describe "#update" do

        it "redirects to the dashboard" do
          get :edit, :id => 1
          response.should redirect_to root_path
        end
      end
    end
  end

  context "For authenticated users" do

    before do
      @current_user = mock(User).as_null_object
      controller.stub(:current_user).and_return(@current_user)
    end

    describe "#new" do

      it "redirects to the root" do
        get :new
        response.should redirect_to root_path
      end
    end

    describe "#create" do

      it "redirects to the root" do
        post :create, :user => {"foo" => "bar"}
        response.should redirect_to root_path
      end
    end


    context "who are unauthorized" do

      before do
        User.stub(:find).and_return( @found_user = mock(User).as_null_object)
        controller.stub(:current_user?).and_return(false)
      end

      describe "#edit" do

        it "redirects to the root path" do
          get :edit, :id => 1
          response.should redirect_to root_path
        end
      end

      describe "#update" do

        it "redirects to the root path" do
          @atts = {"foo" => "bar"}
          put :update, :id => 1, :user => @atts
          response.should redirect_to root_path
        end
      end
    end

    context "who are authorized" do

      before do
        User.stub(:find).and_return(@current_user)
      end

      describe "#edit" do

        it "sets the title" do
          get :edit, :id => 1
          assigns(:title).should_not be_empty
        end

        it "finds the user" do
          User.should_receive(:find).with("1")
          get :edit, :id => 1
        end

        it "assigns the user" do
          get :edit, :id => 1
          assigns(:user).should == @current_user
        end
      end

      describe "successful #update" do

        before do
          @atts = {"foo" => "bar"}
          @current_user.stub(:update_attributes).and_return(true)
        end

        it "updates the user's attributes with the parameters" do
          @current_user.should_receive(:update_attributes).with(@atts)
          put :update, :id => 1, :user => @atts
        end

        it "sets a flash message" do
          put :update, :id => 1, :user => @atts
          flash[:success].should_not be_blank
        end

        it "redirects to the root path" do
          put :update, :id => 1, :user => @atts
          response.should redirect_to root_path
        end
      end

      describe "failed #update" do

        before do
          @current_user.stub(:update_attributes).and_return(false)
        end

        it "sets the title" do
          put :update, :id => 1
          assigns(:title).should_not be_blank
        end

        it "renders the edit user template" do
          put :update, :id => 1
          response.should render_template :edit
        end
      end
    end
  end
end
