class FacebookSessionsController < ApplicationController
  skip_before_filter :authenticate_user!

  def create
    user                       = FacebookUser.from_omniauth(env["omniauth.auth"])
    session[:facebook_user_id] = user.id
    email = Admin::Customer::Email.find_by_id(session[:admin_customer_email_id]) rescue nil
    if email
      redirect_to minisite_email_offers_url(email.tracking)
    else
      redirect_to root_url
    end
  end

  def destroy
    session[:facebook_user_id] = nil
    email = Admin::Customer::Email.find_by_id(session[:admin_customer_email_id]) rescue nil
    if email
      redirect_to minisite_email_offers_url(email.tracking)
    else
      redirect_to root_url
    end
  end
end