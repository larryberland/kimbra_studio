module Minisite
  class EmailsController < BaseController

    before_filter :setup_new_client, only: [:new]
    skip_before_filter :setup_session, only: [:order_status]

    def about
      @navbar_active = :brand
      @storyline.describe "Viewing About #{@studio.name}."
    end

    def contact
      @storyline.describe 'Viewing Contact Us.'
    end

            # Accepts cart tracking.
    def order_status
      @cart_order = Shopping::Cart.find_by_tracking(params[:cart])
      if @cart_order
        @storyline.describe 'Viewing completed order receipt page.'
                                                            # Because we are skipping before_filters, need to set these up here.
        @admin_customer_email = @cart_order.email
        @studio               = @admin_customer_email.my_studio_session.studio
        @show_status_only     = !!params[:show_status_only] # Convert "true" into true.
                                                            # Set up a new cart in case the consumer wants to purchase more from this offer email.
        @cart                 = Shopping::Cart.create(:email => @admin_customer_email)
        session[:cart_id]     = @cart.id
      else
        @storyline.describe "Try to view order status for non-existent cart: #{params[:cart]}"
        return render(text: "No cart found with tracking number: #{params[:cart]}.")
      end
    end

    def privacy
      @storyline.describe 'Viewing Privacy statement.'
    end

    def returns
      @storyline.describe 'Viewing Returns statement.'
    end

    def unsubscribe
      address = @admin_customer_email.my_studio_session.client.email
      if address
        Unsubscribe.create(email: address) unless Unsubscribe.exists?(email: address)
        @storyline.describe "Unsubscribing #{@client.name} from emails (#{address})."
      else
        @storyline.describe "Cannot unsubscribe. No email found with tracking number #{params[:id]}."
        return render(text: 'No email found with that tracking number.')
      end
    end

    # Use this to wipe your session so you can view a different offer email.
    def kill_session
      reset_session
      return render(text: "Session has been wiped at #{Time.now.in_time_zone("Eastern Time (US & Canada)").to_s(:day_time)}.")
    end

    private #================================================

    # overriding BaseController's to get email instead of offer
    def load_email_or_cart
      Rails.logger.info("Filter: load_email_or_cart params id:#{params[:id]}")
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id]) if params[:id]
      sync_session_email(@admin_customer_email)
    end

  end
end