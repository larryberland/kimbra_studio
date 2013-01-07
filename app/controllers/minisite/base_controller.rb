module Minisite

  class BaseController < ApplicationController

    # These filters do not get called by Inherited Resource Controllers
    skip_before_filter :authenticate_user!
    before_filter :setup_session, except: [:kill_session]
    before_filter :handle_roles
    before_filter :setup_story, except: [:kill_session]

    layout 'minisite'

    private #===========================================================================

    # override the ApplicationController's navbar_active
    # :collection, :charms, :chains, :brand, :shopping_cart
    def navbar_active
      # reset in controller for active navbar menu item
      @navbar_active = :collection
    end

    def handle_roles
      unless (is_client?)
        puts "base handle roles"
        @studio             = @admin_customer_email.my_studio_session.studio
        @admin_customer_friend = Admin::Customer::Friend.new(email: @admin_customer_email,
                                                             name:  @admin_customer_email.my_studio_session.client.name)
      end
    end

  end

end