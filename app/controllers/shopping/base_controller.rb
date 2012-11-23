class Shopping::BaseController < InheritedResources::Base

  skip_filter :authenticate_user!
  before_filter :set_client_and_cart
  before_filter :setup_story, except: [:edit_delivery_tracking, :update_delivery_tracking]

  layout 'minisite'

  private #================================================================================

  # We don't support changing between multiple clients or emails in one session.
  def set_client_and_cart
    if params[:shopping_item] && params[:shopping_item][:offer_id]
      @admin_customer_offer = Admin::Customer::Offer.find(params[:shopping_item][:offer_id])
      session[:admin_customer_offer_id] = @admin_customer_offer.id
      @shopping_item_id = params[:shopping_item][:offer_id]
    elsif params[:shopping_item] && params[:shopping_item][:piece_id]
      @shopping_item_id = params[:shopping_item][:piece_id]
    else
      @admin_customer_offer = Admin::Customer::Offer.find(session[:admin_customer_offer_id]) if session[:admin_customer_offer_id]
      @shopping_item_id = @admin_customer_offer.id
    end
#    @studio = @admin_customer_email.my_studio_session.studio
    @studio = Studio.find(session[:studio_id])
    @client = MyStudio::Client.find(session[:client_id]) if session[:client_id].present?
    @cart = Shopping::Cart.find_by_tracking(params[:id]) if params[:id]
    @cart = Shopping::Cart.find(session[:cart_id]) if @cart.nil? && session[:cart_id]
    @admin_customer_email = @cart.email
  end

end