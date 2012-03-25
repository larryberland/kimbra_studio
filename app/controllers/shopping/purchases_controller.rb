module Shopping
  class PurchasesController < BaseController
    belongs_to :cart,
                 :parent_class => Shopping::Cart,
                 :singleton    => true

    def new
      new! do
        @purchase.cart        = @cart
        @purchase.total       = @cart.to_total
        @purchase.total_cents = @purchase.total * 100.0
      end
    end

    def create
      create! do
        if @purchase.errors.present?
          edit_shopping_purchase_path(@purchase)
        else
          shopping_stripe_card_path(@purchase.stripe_card)
        end
      end

    end

    def update
      update! do
        if @purchase.errors.present?
          edit_shopping_purchase_path(@purchase)
        else
          shopping_stripe_card_path(@purchase.stripe_card)
        end
      end

    end

  end
end