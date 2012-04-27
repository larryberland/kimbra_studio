module Minisite

  class BaseController < ApplicationController

    skip_before_filter :authenticate_user!
    before_filter :load_email
    before_filter :set_by_tracking
    before_filter :set_cart_and_client_and_studio
    before_filter :setup_story

    layout 'minisite'

    private #===========================================================================

    def load_email
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:email_id]) if params[:email_id]
    end

    def set_by_tracking
      @admin_customer_offer = Admin::Customer::Offer.find_by_tracking(params[:id]) if params[:id]
      @admin_customer_email ||= @admin_customer_offer.email if @admin_customer_offer
    end

    def set_cart_and_client_and_studio
      if session[:cart_id]
        @cart = Shopping::Cart.find(session[:cart_id]) rescue nil
      end
      if @cart.nil?
        @cart             = Shopping::Cart.create(:email => @admin_customer_email)
        session[:cart_id] = @cart.id
      end
      session[:admin_customer_email_id] = @admin_customer_email.id
      @client                           = @admin_customer_email.my_studio_session.client
      session[:client_id]               ||= @client.id
      @studio                           = @admin_customer_email.my_studio_session.studio
      session[:studio_id]               ||= @studio.id
    end

  end

end