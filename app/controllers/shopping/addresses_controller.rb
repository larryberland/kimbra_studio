module Shopping
  class AddressesController < BaseController

    before_filter :form_info, only: [:new, :edit]

    belongs_to :cart,
               parent_class: Shopping::Cart,
               singleton:    true,
               finder:       :find_by_tracking

    def new
      @storyline.describe 'Entering new address.'
      new! do
        return render("new#{@shopping_layout}")
      end
    end

    def create
      create! do |success, failure|
        success.html do
          @storyline.describe 'Created new address.'
          url = if @cart.shipping
            edit_shopping_cart_shipping_path(@cart, @cart.shipping)
          else
            new_shopping_cart_shipping_path(@cart)
          end
          redirect_to url
        end
        failure.html do
          form_info
          @storyline.describe "Error in creating new address: #{@address.errors.full_messages}"
          return render("new#{@shopping_layout}")
        end

      end
    end

    def edit
      @storyline.describe 'Editing the address.'
      edit! do
        return render("edit#{@shopping_layout}")
      end
    end

    def update
      update! do |success, failure|
        success.html do
          @storyline.describe 'Updated the address.'
          url = if @cart.shipping
            edit_shopping_cart_shipping_path(@cart, @cart.shipping)
          else
            new_shopping_cart_shipping_path(@cart)
          end
          redirect_to url
        end
        failure.html do
          form_info
          @storyline.describe "Error in updating new address: #{@address.errors.full_messages}"
          # render directly so we can see the @address.errors
          render("edit#{@shopping_layout}")
        end
      end
    end

    private

    def form_info
      @states = State.form_selector
    end

  end

end