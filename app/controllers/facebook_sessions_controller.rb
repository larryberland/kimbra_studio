class FacebookSessionsController < ApplicationController

  skip_before_filter :authenticate_user!

  respond_to :js, :only => [:share]

  def create
    user                       = FacebookUser.from_omniauth(env["omniauth.auth"])
    session[:facebook_user_id] = user.id
    if (params[:state])
      post_to_time_line(params[:state])
      flash[:notice] = t(:facebook_post_to_time_line, name: @offer.name)
      redirect_to minisite_email_offers_url(@offer.email.tracking)
    else
      redirect_to root_url
    end
  end

  def failure
    # user failed in facebook login
    email = Admin::Customer::Email.find_by_id(session[:email_id]) rescue nil
    if email
      redirect_to minisite_email_offers_url(email.tracking)
    else
      redirect_to root_url
    end
  end

  def destroy
    session[:facebook_user_id] = nil
    email = Admin::Customer::Email.find_by_id(session[:email_id]) rescue nil
    if email
      redirect_to minisite_email_offers_url(email.tracking)
    else
      redirect_to root_url
    end
  end

  def like
    # TODO: Figure out the difference between share and like
    if (current_user_facebook)
      post_to_time_line(params[:id])
    else
      #redirect_to url_for('/auth/facebook', {method: :post})
    end
  end

  private

  def post_to_time_line(offer_id)
    @offer             = Admin::Customer::Offer.find_by_id(offer_id)
    @shopping_item_id = @offer.id
    @item             = @offer
    current_user_facebook.like(@offer, minisite_email_offer_url(@offer.email, @offer))
  end

  def facebook_logout
    split_token    = current_user_facebook.oauth_token.split("|")
    fb_api_key     = split_token[0]
    fb_session_key = split_token[1]
    redirect_to "http://www.facebook.com/logout.php?api_key=#{fb_api_key}&session_key=#{fb_session_key}&confirm=1&next=#{destroy_user_session_url}";
  end
end