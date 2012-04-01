module Minisite
  class EmailsController < BaseController

    def about
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id])
      set_cart_and_client_and_studio
    end

    private #================================================

    def set_by_tracking
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id]) if params[:id]
    end

  end
end
