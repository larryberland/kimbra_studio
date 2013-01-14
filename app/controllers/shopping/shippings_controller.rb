module Shopping
  class ShippingsController < BaseController

    belongs_to :cart,
               parent_class: Shopping::Cart,
               singleton:    true,
               finder: :find_by_tracking

    def new
      @storyline.describe 'Viewing shipping options.'
      @shipping_options = ShippingOption.form_selections
      new! do
        @shipping.shipping_option = @shipping_options.first.last
      end
    end

    def create
      @cart = Shopping::Cart.find(params[:shopping_shipping][:cart_id])
      shipping_option = ShippingOption.find_by_name(params[:shopping_shipping][:shipping_option])
      @shipping = @cart.create_shipping(shipping_option: shipping_option.name, total_cents: shipping_option.cost_cents)
      if @shipping.errors.present?
        @storyline.describe "Errors in shipping: #{@shipping.errors.full_messages}."
        @shipping_options = ShippingOption.form_selections
        return render(:edit)
      else
        @storyline.describe "Shipping option selected: #{@shipping.shipping_option}."
        return redirect_to new_shopping_cart_purchase_path(@cart)
      end
    end

    def edit
      @storyline.describe "Editing shipping option."
      @shipping_options = ShippingOption.form_selections
      edit!
    end

    def update
      update! do
        if @shipping.errors.present?
          @storyline.describe "Errors in shipping: #{@shipping.errors.full_messages}."
          edit_shopping_cart_shipping_path(@shipping.cart, @shipping)
        else
          @storyline.describe "Shipping option selected: #{@shipping.shipping_option}."
          @shipping.total_cents = ShippingOption.find_by_name(params[:shopping_shipping][:shipping_option]).cost_cents
          new_shopping_cart_purchase_path(@cart)
        end
      end
    end

  end
end