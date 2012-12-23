module Minisite

  class BaseController < ApplicationController

    skip_before_filter :authenticate_user!
    before_filter :load_email
    before_filter :set_by_tracking
    before_filter :set_cart_and_client_and_studio
    before_filter :setup_story

    layout 'minisite'

    private #===========================================================================

    # current navbar minisite menu
    # :collection, :charms, :chains, :brand, :shopping_cart
    def navbar_active
      # reset in controller for active navbar menu item
      @navbar_active = :collection
    end

    # TODO - REMEMBER THIS! This logic is not multi-session safe. Meaning that if you flit from one
    # offer email to another, only the first offer email data is kept in the rails session. Unlikely
    # to be a problem in real life, but worth refactoring away some time.

    # TODO See TODO below.
    def load_email
      puts "SESSION: #{session.inspect}"
      @client_info ||= {}
      if params[:email_id]
        # client is usually going to the email offers index page
        @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:email_id])
        @client_info[:honor_email] = true if @admin_customer_email.present?
      end
    end

    # TODO See TODO below.
    def set_by_tracking
      @client_info ||= {}
      if params[:id]
        # client selecting to view a single Offer within the Offer Email
        @admin_customer_offer = Admin::Customer::Offer.find_by_tracking(params[:id])
        if @admin_customer_offer
          @client_info[:honor_offer] = true
          if Rails.env.development?
            if @admin_customer_email
              puts "params:#{params.inspect}"
              puts "offer:#{@admin_customer_offer.inpsect}"
              puts "offer:#{@admin_customer_email.inpsect}"
              raise "who set the email for me it should be set from the Offer info"
            end
          end
          # if email has not already been set then override with this offers email
          @admin_customer_email ||= @admin_customer_offer.email
        end
      end
    end

    # this should only be called by set_cart_and_client_and_studio
    def set_session_cart
      # Pull cart from current session; usually normal shopping activity.
      if @cart.nil? && session[:cart_id]
        # incoming url does not have a cart
        #   see if the session has a valid cart
        @cart = Shopping::Cart.find(session[:cart_id]) rescue nil
        if @cart
          # override the email record with the cart's info
          @admin_customer_email = @cart.email
        end
      end

      # Otherwise create new cart; we are starting a new shopping session.
      # Offer and email are already set.
      if @cart.nil?
        @cart             = Shopping::Cart.create(email: @admin_customer_email)
        session[:cart_id] = @cart.id
      end

    end

    # TODO This logic is tortured. Need to outline the different ways we get to this controller and set session vars accordingly.
    # 1. From session begun by offer email.
    # 2. From session begun by confirmation email offer status link.
    # 3. From bookmarks to any interior page.
    # 4. where else?!? don't forget combinations of the above.
    def set_cart_and_client_and_studio

      if Rails.env.development?
      puts "keys:#{params.keys.join(", ")}"
      puts @admin_customer_email.inspect
      puts @admin_customer_offer.inspect
      end

      # Pull cart from incoming link; usually confirmation email order status link.
      if params[:cart]
        # have a shopping cart to use
        @cart                 = Shopping::Cart.find_by_tracking(params[:cart])
        @admin_customer_email = @cart.email
        @admin_customer_offer = nil
      end

      if (is_client?)
        set_session_cart
        session[:admin_customer_email_id] = @admin_customer_email.id

        @client             = @admin_customer_email.my_studio_session.client
        session[:client_id] ||= @client.id

        @studio                = @admin_customer_email.my_studio_session.studio
        session[:studio_id]    ||= @studio.id

        # current collection friend name
        if (session[:admin_customer_friend_id])
          @admin_customer_friend = Admin::Customer::Friend.find_by_id(session[:admin_customer_friend_id])
        else
          # client is coming in with a new session
          @admin_customer_friend = @admin_customer_email.create_friend(@cart)
          session[:admin_customer_friend_id] = @admin_customer_friend.id
        end

      elsif (is_studio?)
        # studio and admin should have @cart and @client nil
        @studio = current_user.studio

      else

        set_session_cart
        @studio             = @admin_customer_email.my_studio_session.studio
        # shopping session info
        session[:studio_id] = @studio.id

      end
    end

  end

end