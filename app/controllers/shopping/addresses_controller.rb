module Shopping
  class AddressesController < BaseController

    def new
      @states = State.form_selector
      @storyline.describe "Entering new address."
      new!
    end

    def create
      @storyline.describe "Creating new address."
      create! do
        if @address.errors.present?
          @states = State.form_selector
          return render(:new)
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
      @storyline.describe "Editing the address."
      @states = State.form_selector
      edit!
    end

    def update
      @storyline.describe "Updating the address."
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