module Shopping
  class PurchasesController < BaseController

    belongs_to :cart,
               :parent_class => Shopping::Cart,
               :singleton => true

    def new
      new! do
        @purchase.cart = @cart
        @purchase.total_cents = @purchase.total * 100.0
      end
    end

    def create
      create! do
        if @purchase.errors.present?
          edit_shopping_cart_purchase_path(@cart)
        else
          # After the credit card is run (successful create) we need to close out
          # this cart so that the consumer will start a new one if they want to make
          # more purchases.
          @cart = nil
          session[:cart_id] = nil
          @admin_customer_offer = nil
          session[:admin_customer_offer_id] = nil
          shopping_stripe_card_path(@purchase.stripe_card)
        end
      end
    end

    def update
      update! do
        if @purchase.errors.present?
          edit_shopping_cart_purchase_path(@cart)
        else
          # After the credit card is run (successful create) we need to close out
          # this cart so that the consumer will start a new one if they want to make
          # more purchases.
          @cart = nil
          session[:cart_id] = nil
          @admin_customer_offer = nil
          session[:admin_customer_offer_id] = nil
          shopping_stripe_card_path(@purchase.stripe_card)
        end
      end
    end

  end
end