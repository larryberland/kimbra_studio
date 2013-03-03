class Shopping::BaseController < InheritedResources::Base

  skip_filter :authenticate_user!
  before_filter :handle_roles
  before_filter :setup_story
  before_filter :navbar_active
  before_filter :shopping_layout


  layout 'minisite'

  private #================================================================================

  def shopping_layout
    # basically a way to try out new styles for our Shopping Checkout/Purchase experience
    # This will append the @shopping_layout value to our
    # :new, :create, :update, etc actions
    #  simply comment out next line to go back to original view layouts
    @shopping_layout = '_breadcrumb' # note: the underscore in front
  end

  def handle_roles
    unless (is_client?)
      @studio                = @admin_customer_email.my_studio_session.studio
      @admin_customer_friend = Admin::Customer::Friend.new(email: @admin_customer_email,
                                                           name:  @admin_customer_email.my_studio_session.client.name)
    end
  end

          # current navbar menu
          # :collection, :charms, :chains, :brand, :shopping_cart
  def navbar_active
    # reset in controller for active navbar menu item
    @navbar_active = :shopping_cart
  end

  def sync_cart

    if (@cart)
      # if we have a current session email and cart that is different than the
      #   current request, push it onto the session[:email_cart] hash for referencing later
      if session[:cart_id] or session[:email_id]
        if ((session[:cart_id] != @cart.id) or (session[:email_id] != @cart.email.id))
          push_session_email_cart
        end
      end

      # reestablish the current session email and cart info
      session[:cart_id]  = @cart.id
      session[:email_id] = @cart.email.id

      session[:email_cart][@cart.email.id] = @cart.id

      @admin_customer_email = @cart.email

    else
      raise "want to know why we don't have a cart"
    end

    @admin_customer_friend = Admin::Customer::Friend.find_by_id(session[:friend_id])
    @admin_customer_friend  = @cart.email.create_friend(@cart) if @admin_customer_friend.nil?

  end
  # override the ApplicationController's handling of
  # session cart information
  def load_email_or_cart
    load_shopping_item_or_not

    if params[:cart_id]
      # for inherited resources
      @cart = Shopping::Cart.find_by_tracking(params[:cart_id])
    elsif params[:id]
      # for non inherited resources
      raise "who is overriding my client id by tracking?" unless @cart.nil?
      @cart = Shopping::Cart.find_by_tracking(params[:id])
      raise "want to know why we dont have a cart and should redirect probably" if @cart.nil?
    end
    sync_cart
  end

  # We don't support changing between multiple clients or emails in one session.
  def load_shopping_item_or_not
    @shopping_item_id = nil

    if si = params[:shopping_item]
      if si[:offer_id]
        # this is a shopping item that references an offer and cart
        @shopping_item_id                 = si[:offer_id]
        @admin_customer_offer             = Admin::Customer::Offer.find(si[:offer_id])
        @cart                             = Shopping::Cart.find_by_id(si[:cart_id])
        session[:admin_customer_offer_id] = @admin_customer_offer.id
        raise "cart offer email mismatch" if (@cart.email.id != @admin_customer_offer.email.id)
      elsif si[:piece_id]
        @shopping_item_id = si[:piece_id]
      end
    end

    unless @shopping_item_id
      @admin_customer_offer = Admin::Customer::Offer.find(session[:admin_customer_offer_id]) if session[:admin_customer_offer_id]
      @shopping_item_id = @admin_customer_offer.id if @admin_customer_offer
    end

  end

end