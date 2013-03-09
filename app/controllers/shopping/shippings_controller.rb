module Shopping
  class ShippingsController < BaseController

    before_filter :form_info, only: [:new, :edit]

    belongs_to :cart,
               parent_class: Shopping::Cart,
               singleton:    true,
               finder:       :find_by_tracking

    def new
      @storyline.describe 'Viewing shipping options.'
      new! do
        @shipping.shipping_option_name = @shipping_options.first.last
        return render("new#{@shopping_layout}")
      end
    end

    def create
      create! do |success, failure|
        success.html do
          puts "SUCCESS: shipping:#{@shipping.inspect}"
          @storyline.describe "Shipping option selected: #{@shipping.shipping_option_name}."
          redirect_to new_shopping_cart_purchase_path(@cart)
        end
        failure.html do
          puts "FAILURE: shipping:#{@shipping.inspect}"
          form_info
          @storyline.describe "Errors in shipping: #{@shipping.errors.full_messages}."
          return render("new#{@shopping_layout}")
        end
      end
    end

    def edit
      @storyline.describe 'Editing shipping option.'
      edit! do
        return render("edit#{@shopping_layout}")
      end
    end

    def update
      update! do |success, failure|
        success.html do
          @storyline.describe "Shipping option selected: #{@shipping.shipping_option_name}."
          redirect_to new_shopping_cart_purchase_path(@cart)
        end
        failure.html do
          @storyline.describe "Errors in shipping: #{@shipping.errors.full_messages}."
          redirect_to edit_shopping_cart_shipping_path(@cart, @shipping)
        end
      end
    end

    private

    def form_info
      @shipping_options = ShippingOption.form_selections
    end

  end
end