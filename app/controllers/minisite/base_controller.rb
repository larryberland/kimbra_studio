module Minisite

  class BaseController < ApplicationController

    # These filters do not get called by Inherited Resource Controllers
    skip_before_filter :authenticate_user!
    before_filter :load_email
    before_filter :set_by_tracking
    before_filter :set_cart_and_client_and_studio
    before_filter :setup_story

    layout 'minisite'

    private #===========================================================================

    # override the ApplicationController's navbar_active
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
      Rails.logger.info "SESSION: #{session.inspect}"
      if params[:email_id]
        # client is usually going to the email offers index page
        @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:email_id])
      end
    end

    # TODO See TODO below.
    def set_by_tracking
      if params[:id]
        # client selecting to view a single Offer within the Offer Email
        @admin_customer_offer = Admin::Customer::Offer.find_by_tracking(params[:id])
        if @admin_customer_offer
          # if email has not already been set then override with this offers email
          @admin_customer_email ||= @admin_customer_offer.email
        end
      end
    end

  end

end