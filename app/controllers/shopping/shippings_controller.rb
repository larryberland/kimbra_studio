module Shopping
  class ShippingsController < BaseController

    def new
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
        @shipping_options = ShippingOption.form_selections
        return render(:edit)
      else
        return redirect_to new_shopping_cart_purchase_path(@cart)
      end
    end

    def edit
      @shipping_options = ShippingOption.form_selections
      edit!
    end

    def update
      update! do
        if @shipping.errors.present?
          edit_shopping_shipping_path(@shipping)
        else
          @shipping.total_cents = ShippingOption.find_by_name(params[:shopping_shipping][:shipping_option]).cost_cents
          new_shopping_cart_purchase_path(@cart)
        end
      end
    end

  end
end