module Shopping
  class AddressesController < BaseController

    def new
      @states = State.form_selector
      new!
    end

    def create
      create! do
        if @address.errors.present?
          edit_shopping_address_path(@address)
        else
          if @cart.shipping
            edit_shopping_shipping_path(@cart.shipping)
          else
            new_shopping_shipping_path
          end
        end
      end
    end

    def edit
      @states = State.form_selector
      edit!
    end

    def update
      update! do
        if @address.errors.present?
          edit_shopping_address_path(@address)
        else
          if @cart.shipping
            edit_shopping_shipping_path(@cart.shipping)
          else
            new_shopping_shipping_path
          end
        end
      end
    end

  end
end