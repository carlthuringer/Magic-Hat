class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  before_filter :authorized_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

  def new
    redirect_to root_path if signed_in?
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    # TODO This is pretty weird. Why does the controller need to handle the
    # case where a POST create is attempted by a user that already exists?
    # There must be a way to do this in a before filter.
    if signed_in?
      redirect_to root_path
    elsif @user.save
      sign_in @user
      flash[:success] = "Account Created!"
      redirect_back_or dashboard_path
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
    if @user.update_attributes params[:user]
      flash[:success] = "Account updated."
      redirect_to root_path
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  private

  def authorized_user
    @user = User.find params[:id]
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin
  end

end
