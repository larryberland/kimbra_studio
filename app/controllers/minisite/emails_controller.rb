module Minisite
  class EmailsController < BaseController

    skip_before_filter :set_by_tracking, :set_cart_and_client_and_studio, only: :order_status

    def about
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id])
      set_cart_and_client_and_studio
    end

    # Accepts cart tracking.
    def order_status
      @cart_order = Shopping::Cart.find_by_tracking(params[:cart])
      return render(text: "No cart found with tracking number: #{params[:cart]}.") unless @cart_order
      # Because we are skipping before_filters, need to set these up here.
      @admin_customer_email = @cart_order.email
      @studio = @admin_customer_email.my_studio_session.studio
      @show_status_only = !!params[:show_status_only] # Convert "true" into true.
      # Set up a new cart in case the consumer wants to purchase more from this offer email.
      @cart = Shopping::Cart.create(:email => @admin_customer_email)
      session[:cart_id] = @cart.id
    end

    def unsubscribe
      address = @admin_customer_email.my_studio_session.client.email
      if address
        Unsubscribe.create(email: address) unless Unsubscribe.exists?(email: address)
        @storyline.describe 'Unsubscribing from emails.'
      else
        @storyline.describe 'Cannot unsubscribe. No email found with that tracking number.'
        return render(text: 'No email found with that tracking number.')
      end
    end

    private #================================================

    def set_by_tracking
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id]) if params[:id]
    end

  end
end
