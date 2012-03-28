class Minisite::ShowroomsController < InheritedResources::Base

  layout 'showroom'

  def collection
    @admin_customer_email = Admin::Customer::Email.where(:tracking => params[:id]).first
    set_client_and_cart
  end

  def offer
    @admin_customer_offer = Admin::Customer::Offer.where(:tracking => params[:id]).first
    @admin_customer_email = @admin_customer_offer.email
    set_client_and_cart
  end

  def about
      @admin_customer_email = Admin::Customer::Email.where(:tracking => params[:id]).first
      set_client_and_cart
    end

  private #=======================================================

  # We use tracking for offers and emails. A showroom equates to an email:
  # it is a collection of offers. Because we are using tracking instead of ids
  # we need to load the email and offer from tracking.
  def set_client_and_cart
    @showroom = @admin_customer_email.showroom
    @client = @admin_customer_email.my_studio_session.client
    session[:client_id] = @client.id if @client
    @client = MyStudio::Client.find(session[:client_id]) if @client.nil? && session[:client_id].present?
    @cart = if @showroom.cart
              @showroom.cart
            else
              Shopping::Cart.new(:showroom => @showroom)
            end
    @cart = @showroom.cart
  end

  # We use tracking number instead of :id in routes. Use tracking to establish showroom.
  # Use showroom to establish client. Use session to store both.
  # Client and showroom should always be in the session after the first visit.
  # We don't support changing between multiple clients or showrooms in one session.
  def set_by_tracking
    @showroom = Minisite::Showroom.find_by_tracking(params[:id]) if params[:id]
    @showroom = Minisite::Showroom.find(session[:showroom_id]) if @showroom.nil? && session[:showroom_id]
    session[:showroom_id] = @showroom.id
    @client = @showroom.client if @showroom
    session[:client_id] = @client.id if @client
    @client = MyStudio::Client.find(session[:client_id]) if @client.nil? && session[:client_id].present?
    @cart = if @showroom.cart
              @showroom.cart
            else
              Shopping::Cart.new(:showroom => @showroom)
            end
    @cart = @showroom.cart
  end

end