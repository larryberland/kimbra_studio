class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :authenticate_user!

  def require_user
    redirect_to login_url and return if logged_out?
  end

  def logged_out?
    !current_user
  end

end