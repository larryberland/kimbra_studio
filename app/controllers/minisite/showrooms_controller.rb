class Minisite::ShowroomsController < InheritedResources::Base

  skip_filter :authenticate_user!

  layout 'showroom'

  def collection
    @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id])
    set_cart_and_client_and_studio
  end

  def offer
    @admin_customer_offer = Admin::Customer::Offer.find_by_tracking(params[:id])
    @admin_customer_email = @admin_customer_offer.email
    set_cart_and_client_and_studio
    @shopping_item = Shopping::Item.new(:offer => @admin_customer_offer, :cart => @cart)
  end


  private #=======================================================

  def set_cart_and_client_and_studio

    if session[:cart_id]
      @cart = Shopping::Cart.find(session[:cart_id]) rescue nil
    end

    if @cart.nil?
      @cart = Shopping::Cart.create(:email => @admin_customer_email)
      session[:cart_id] = @cart.id
    end
    session[:admin_customer_email_id] = @admin_customer_email.id
    @client = @admin_customer_email.my_studio_session.client
    session[:client_id] ||= @client.id
    @studio = @admin_customer_email.my_studio_session.studio
    session[:studio_id] ||= @studio.id
  end

end