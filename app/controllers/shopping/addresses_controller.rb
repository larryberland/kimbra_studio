module Shopping
  class AddressesController < BaseController

    def new
      @states = State.form_selector
      @storyline.describe 'Entering new address.'
      new!
    end

    def create
      create! do
        if @address.errors.present?
          @states = State.form_selector
          @storyline.describe "Error in creating new address: #{@address.errors.full_messages}"
          return render(:new)
        else
          @storyline.describe 'Creating new address.'
          if @cart.shipping
            edit_shopping_shipping_path(@cart.shipping)
          else
            new_shopping_shipping_path
          end
        end
      end
    end

    def edit
      @storyline.describe 'Editing the address.'
      @states = State.form_selector
      edit!
    end

    def update
      update! do
        if @address.errors.present?
          @states = State.form_selector
          @storyline.describe "Error in updating new address: #{@address.errors.full_messages}"
          edit_shopping_address_path(@address)
        else
          @storyline.describe 'Updating the address.'
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