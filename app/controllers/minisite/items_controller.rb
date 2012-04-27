class Minisite::ItemsController < InheritedResources::Base

  belongs_to :offer,
             :parent_class => Admin::Customer::Offer

  skip_before_filter :authenticate_user!
  before_filter :set_by_tracking, :set_cart_and_client_and_studio
  before_filter :setup_story

  layout 'minisite'

  def index
    index!
  end

  def update
    puts "params=>#{params.inspect}"
    @item  = Admin::Customer::Item.find(params[:id])
    offset = [@item.part.part_layout.x, @item.part.part_layout.y]
    size   = [@item.part.part_layout.w, @item.part.part_layout.h]

    update! do |success, failure|

      success.html { render action: "edit" }
      failure.html { render action: "edit" }
    end
  end

  private

  def set_by_tracking
    @offer = Admin::Customer::Offer.find_by_tracking(params[:id]) if params[:id]
    @offer = Admin::Customer::Offer.find_by_tracking(params[:offer_id]) if params[:offer_id]
    @email ||= @offer.email if @offer
  end

  def set_cart_and_client_and_studio
    if session[:cart_id]
      @cart = Shopping::Cart.find(session[:cart_id]) rescue nil
    end

    if @cart.nil?
      @cart             = Shopping::Cart.create(:email => @email)
      session[:cart_id] = @cart.id
    end
    session[:admin_customer_email_id] = @email.id
    @client                           = @email.my_studio_session.client
    session[:client_id]               ||= @client.id
    @studio                           = @email.my_studio_session.studio
    session[:studio_id]               ||= @studio.id
    @admin_customer_email = @email
    @admin_customer_offer = @offer
  end

end
