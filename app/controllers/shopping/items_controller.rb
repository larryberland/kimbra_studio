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

    def destroy
      @item = Shopping::Item.find(params[:id])
      @storyline.describe "Removing all #{@item.offer.name} from cart."
      @item.destroy
      respond_to do |format|
        format.js {render(:update)}
      end
    end

    def remove_one
      @item = Shopping::Item.find(params[:id])
      @storyline.describe "Removing one #{@item.offer.name} from cart."
      @item.update_attribute :quantity, @item.quantity.to_i - 1
      @item.destroy if @item.quantity.to_i == 0
      respond_to do |format|
        format.js {render(:update)}
      end
    end

  end
end