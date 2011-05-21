class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

  def new
    redirect_to current_user if signed_in?
    @user = User.new
    @title = "Sign up"
  end

  def index
    @title = "All users"
    @users = User.paginate :page => params[:page]
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def followers
    @title = "Followers"
    @user = User.find params[:id]
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def create
    @user = User.new(params[:user])
    if signed_in?
      redirect_to dashboard_path
    elsif @user.save
      sign_in @user
      flash[:success] = "Account Created!"
      redirect_to dashboard_path
    else
      @title = "Sign up"
      @user.password = ''
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes params[:user]
      flash[:success] = "Account updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    if current_user == params[:id]
      flash[:error] = "Admins cannot destroy their own accounts."
      redirect_to users_path
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end

  private

  def correct_user
    @user = User.find params[:id]
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin
  end

end
