module Shopping
  class ItemsController < BaseController

    #belongs_to :cart,
    #           :parent_class => Shopping::Cart
    #belongs_to :offer,
    #           :parent_class => Admin::Customer::Offer
    respond_to :js, :only => [:create, :destroy]

    def new
      new!
    end

    def create
      params[:cart_id] = params[:shopping_item][:cart_id]
      params[:offer_id] = params[:shopping_item][:offer_id]
      @storyline.describe "Adding offer #{Admin::Customer::Offer.find(params[:offer_id])} to cart."
      item_already_in_cart = @cart.items.where(:offer_id => params[:offer_id]).first
      if item_already_in_cart
        item_already_in_cart.update_attribute :quantity, item_already_in_cart.quantity.to_i + 1
        @item = item_already_in_cart
      else
        create!
      end
    end

    def update
      @item = Shopping::Item.find(params[:id])
      quantity = params[:quantity].to_i
      @storyline.describe "Changing quantity of #{@item.offer.name} to #{quantity} in cart."
      if quantity == 0
        @item.destroy
      else
        @item.update_attribute :quantity, quantity
      end
      respond_to do |format|
        format.js { render(:update) }
      end
    end

  end
end