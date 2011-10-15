class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  before_filter :set_user_time_zone

  def set_user_time_zone
    Time.zone = current_user.time_zone if current_user
  end
end
