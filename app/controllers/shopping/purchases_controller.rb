module Shopping
  class PurchasesController < BaseController

    belongs_to :cart,
               parent_class: Shopping::Cart,
               singleton:    true

    def new
      @storyline.describe 'Viewing credit card purchase page.'
      new! do
        raise "need a cart to make a purchase params:#{params.inspect}" if @purchase.cart.nil?
        return render("new#{@shopping_layout}")
      end
    end

    def create
      # inherited resources doesn't seem to like having the cart info in here
      logger.info "purchase/create shopping_purchase=>#{params[:shopping_purchase].inspect}"
      cart_info = params[:shopping_purchase].delete(:cart)
      logger.info "purchase/create params_after_delete=>#{params.inspect}"
      create! do |success, failure|
        failure.html do
          @storyline.describe "Errors in cart: #{@purchase.errors.full_messages}."
          return render("edit#{@shopping_layout}")
        end
        success.html do
          @storyline.describe 'Cart purchased!'
          ClientMailer.delay.send_order_confirmation(@cart.id, @studio.id)
          KimbraMailer.delay.send_sales_order(@cart.id, @studio.id)
          # After the credit card is run (successful create) we need to close out
          # this cart so that the consumer will start a new one if they want to make
          # more purchases.
          cart_track                        = @cart.tracking
          @cart                             = nil
          session[:cart_id]                 = nil
          @admin_customer_offer             = nil
          session[:admin_customer_offer_id] = nil
          redirect_to order_status_minisite_email_path(@admin_customer_email, cart: cart_track, show_status_only: true)
          #shopping_stripe_card_path(@purchase.stripe_card)
        end
      end
    end

    def edit
      edit! do
        return render("edit#{@shopping_layout}")
      end
    end

    def update
      # inherited resources doesn't seem to like having the cart info in here
      logger.info "purchase/update=>#{params[:shopping_purchase].inspect}"
      cart_info = params[:shopping_purchase].delete(:cart)
      update! do |success, failure|
        failure.html do
          @storyline.describe "Errors in updated cart: #{@purchase.errors.full_messages}."
          redirect_to edit_shopping_cart_purchase_url(@cart)
        end
        success.html do
          @storyline.describe 'Edited cart purchased!'
          # After the credit card is run (successful create) we need to close out
          # this cart so that the consumer will start a new one if they want to make
          # more purchases.
          @cart                             = nil
          session[:cart_id]                 = nil
          @admin_customer_offer             = nil
          session[:admin_customer_offer_id] = nil
          redirect_to order_status_minisite_email_path(@admin_customer_email, cart: cart_track)
          #shopping_stripe_card_path(@purchase.stripe_card)
        end
      end
    end

  end
end