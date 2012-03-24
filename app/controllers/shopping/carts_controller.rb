class Shopping::CartsController < InheritedResources::Base
  before_filter :set_by_tracking

  layout 'showroom'

  private

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
    params[:showroom_id] = @showroom.id
    @cart = if @showroom.cart
              @showroom.cart
            else
              Shopping::Cart.new(:showroom => @showroom)
            end
    @cart = @showroom.cart
  end
end
