module Minisite

  class BaseController < ApplicationController

    skip_before_filter :authenticate_user!
    before_filter :load_email
    before_filter :set_by_tracking
    before_filter :set_cart_and_client_and_studio
    before_filter :setup_story

    layout 'minisite'

    private #===========================================================================

    # TODO See TODO below.
    def load_email
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:email_id]) if params[:email_id]
    end

    # TODO See TODO below.
    def set_by_tracking
      @admin_customer_offer = Admin::Customer::Offer.find_by_tracking(params[:id]) if params[:id]
      @admin_customer_email ||= @admin_customer_offer.email if @admin_customer_offer
    end

    # TODO This logic is tortured. Need to outline the different ways we get to this controller and set session vars accordingly.
    # 1. From session begun by offer email.
    # 2. From session begun by confirmation email offer status link.
    # 3. From bookmarks to any interior page.
    # 4. where else?!? don't forget combinations of the above.
    def set_cart_and_client_and_studio
      # Pull cart from incoming link; usually confirmation email order status link.
      if params[:cart]
        @cart                 = Shopping::Cart.find_by_tracking(params[:cart])
        @admin_customer_email = @cart.email
        @admin_customer_offer = nil
      end
      # Pull cart from current session; usually normal shopping activity.
      if @cart.nil? && session[:cart_id]
        @cart                 = Shopping::Cart.find(session[:cart_id]) rescue nil
        @admin_customer_email = @cart.email if @cart
      end
      # Otherwise create new cart; we are starting a new shopping session.
      # Offer and email are already set.
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