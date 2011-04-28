class PagesController < ApplicationController
  before_filter :authenticate, :only => :dashboard

  def home
    if signed_in?
      @title = current_user.name
    else
      @title = "Home"
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

end