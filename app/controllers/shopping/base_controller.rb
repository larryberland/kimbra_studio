class Shopping::BaseController < InheritedResources::Base

  skip_filter :authenticate_user!
  before_filter :set_client_and_cart
  before_filter :setup_story, except: [:edit_delivery_tracking, :update_delivery_tracking]
  before_filter :navbar_active

  layout 'minisite'

  private #================================================================================

  # current navbar menu
  # :collection, :charms, :chains, :brand, :shopping_cart
  def navbar_active

    # reset in controller for active navbar menu item
    @navbar_active = :shopping_cart
  end

  # We don't support changing between multiple clients or emails in one session.
  def set_client_and_cart
    @shopping_item_id = nil

    if si = params[:shopping_item]
      if si[:offer_id]
        @admin_customer_offer             = Admin::Customer::Offer.find(si[:offer_id])
        session[:admin_customer_offer_id] = @admin_customer_offer.id
        @shopping_item_id                 = si[:offer_id]
      elsif si[:piece_id]
        @shopping_item_id = si[:piece_id]
      end
    end

    unless @shopping_item_id
      @admin_customer_offer = Admin::Customer::Offer.find(session[:admin_customer_offer_id]) if session[:admin_customer_offer_id]
      @shopping_item_id = @admin_customer_offer.id if @admin_customer_offer
    end

#    @studio = @admin_customer_email.my_studio_session.studio
    @studio = Studio.find(session[:studio_id])
    @client = MyStudio::Client.find(session[:client_id]) if session[:client_id].present?
    @cart = Shopping::Cart.find_by_tracking(params[:id]) if params[:id]
    @cart = Shopping::Cart.find(session[:cart_id]) if @cart.nil? && session[:cart_id]
    @admin_customer_email = @cart.email
  end

end