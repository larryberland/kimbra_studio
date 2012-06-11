module Minisite
  class EmailsController < BaseController

    def about
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id])
      set_cart_and_client_and_studio
    end

    # Accepts cart tracking.
    def order_status
      @cart_order = Shopping::Cart.find_by_tracking(params[:cart])
      return render(text: "No cart found with tracking number: #{params[:cart]}.") unless @cart_order
      @admin_customer_email = @cart_order.email
      # Set up a new cart in case the consumer wants to purchase more from this offer email.
      set_cart_and_client_and_studio
    end

    private #================================================

    def set_by_tracking
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id]) if params[:id]
    end

  end
end
