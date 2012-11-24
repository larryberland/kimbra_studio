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
      if params[:shopping_item] && params[:shopping_item][:piece_id]
        # create an offer from this kimbra_piece and add to the shopping cart
        @admin_customer_offer             = Admin::Customer::Offer.generate_from_piece(@admin_customer_email,
                                                                                       params[:shopping_item][:piece_id])
        params[:shopping_item][:offer_id] = @admin_customer_offer.id
        session[:admin_customer_offer_id] = @admin_customer_offer.id
        @shopping_item_id = params[:shopping_item][:piece_id]
        params[:shopping_item][:from_piece] = true    # after_destroy flag to remove offer
      end
      params[:offer_id] = params[:shopping_item][:offer_id]
      params[:cart_id]  = params[:shopping_item][:cart_id]
      @storyline.describe "Adding #{@admin_customer_offer.name} to cart."
      item_already_in_cart = @cart.items.where(:offer_id => params[:offer_id]).first

      if item_already_in_cart
        item_already_in_cart.update_attribute :quantity, item_already_in_cart.quantity.to_i + 1
        @item = item_already_in_cart
      else
        create!
      end
    end

    def update
      @item    = Shopping::Item.find(params[:id])
      quantity = params[:quantity].to_i
      @storyline.describe "Changing quantity of #{@item.offer.name} to #{quantity} in cart."
      if quantity == 0
        # destroy any offers that came from charms/chains
        @item.destroy
        session[:admin_customer_offer_id] = nil if session[:admin_customer_offer_id]
      else
        @item.update_attribute :quantity, quantity
      end
      respond_to do |format|
        format.js { render(:update) }
      end
    end

  end
end