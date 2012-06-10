module Shopping
  class ShippingsController < BaseController

    def new
      @shipping_options = ShippingOption.form_selections
      new! do
        @shipping.shipping_option = @shipping_options.first.last
      end
      puts "shipping_option: #{@shipping.shipping_option}"
    end

    def create
      create! do
        shipping_option = ShippingOption.find_by_name(params[:shopping_shipping][:shipping_option])
        @shipping.shipping_option = shipping_option.name
        @shipping.total_cents = shipping_option.cost_cents
        @shipping.save
        if @shipping.errors.present?
          edit_shopping_shipping_path(@shipping.id)
        else
          new_shopping_cart_purchase_path(@cart)
        end
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