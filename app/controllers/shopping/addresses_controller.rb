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
          new_shopping_shipping_path
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
          new_shopping_shipping_path
        end
      end
    end

  end
end