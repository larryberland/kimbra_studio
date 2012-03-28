class Shopping::BaseController < InheritedResources::Base
  before_filter :set_client_and_cart

  layout 'showroom'

  private #================================================================================

    # We use tracking number instead of :id in routes. Use tracking to establish showroom.
  # Use showroom to establish client. Use session to store both.
  # Client and showroom should always be in the session after the first visit.
  # We don't support changing between multiple clients or showrooms in one session.
  def set_client_and_cart
    if params[:shopping_item] && params[:shopping_item][:offer_id]
      @admin_customer_offer = Admin::Customer::Offer.find(params[:shopping_item][:offer_id])
      session[:admin_customer_offer_id] = @admin_customer_offer.id
    else
      @admin_customer_offer = Admin::Customer::Offer.find(session[:admin_customer_offer_id])
    end
    @admin_customer_email = @admin_customer_offer.email
    @showroom = @admin_customer_email.showroom
    @client = @admin_customer_email.my_studio_session.client
    @client = MyStudio::Client.find(session[:client_id]) if @client.nil? && session[:client_id].present?
    @cart = if @showroom.cart
              @showroom.cart
            else
              Shopping::Cart.new(:showroom => @showroom)
            end
    @cart = @showroom.cart


    #@showroom = Minisite::Showroom.find_by_tracking(params[:id]) if params[:id]
    #@showroom = Minisite::Showroom.find(session[:showroom_id]) if @showroom.nil? && session[:showroom_id]
    #session[:showroom_id] = @showroom.id
    #@client = @showroom.client if @showroom
    #session[:client_id] = @client.id if @client
    #@client = MyStudio::Client.find(session[:client_id]) if @client.nil? && session[:client_id].present?
    #params[:showroom_id] = @showroom.id
    #@cart = if @showroom.cart
    #          @showroom.cart
    #        else
    #          Shopping::Cart.new(:showroom => @showroom)
    #        end
    #@cart = @showroom.cart
    #@tracking = @showroom.tracking
  end

end