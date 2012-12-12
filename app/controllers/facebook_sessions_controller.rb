class FacebookSessionsController < ApplicationController
  skip_before_filter :authenticate_user!

  respond_to :js, :only => [:share]

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

  def failure
    # user failed in facebook login
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

  def share
    if (current_user_facebook)
      @shopping_item_id = offer.id
      @item = offer
      offer = Admin::Customer::Offer.find_by_id(params[:id])
      current_user_facebook.share(offer, minisite_offer_url(offer))
    end
  end

  def like
    # TODO: Figure out the difference between share and like
    if (current_user_facebook)
      @shopping_item_id = offer.id
      @item = offer
      offer = Admin::Customer::Offer.find_by_id(params[:id])
      current_user_facebook.like(offer, minisite_offer_url(offer))
    end
  end
  private

  def facebook_logout
    split_token    = current_user_facebook.oauth_token.split("|")
    fb_api_key     = split_token[0]
    fb_session_key = split_token[1]
    redirect_to "http://www.facebook.com/logout.php?api_key=#{fb_api_key}&session_key=#{fb_session_key}&confirm=1&next=#{destroy_user_session_url}";
  end
end