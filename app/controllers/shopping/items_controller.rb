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

      item_already_in_cart = @cart.find_item(@admin_customer_offer.id) if @admin_customer_ofer

      if params[:shopping_item] && params[:shopping_item][:piece_id]
        # Someone has picked one of the Kimbra Pieces that is not associated
        #   with our email offer (ex. chains or charms)
        # create an offer from this kimbra_piece and add to the shopping cart
        @admin_customer_offer               = Admin::Customer::Offer.generate_from_piece(@admin_customer_email,
                                                                                         params[:shopping_item][:piece_id])
        params[:shopping_item][:offer_id]   = @admin_customer_offer.id
        session[:admin_customer_offer_id]   = @admin_customer_offer.id
        @shopping_item_id                   = params[:shopping_item][:piece_id]

        # after_destroy flag to remove offer when removing from the shopping cart
        params[:shopping_item][:from_piece] = true
      else
        # sending an offer that has been adjusted and going to the shopping cart
        #   make a copy that is frozen and no one can edit in case they decide
        #   to purchase this offer
        unless item_already_in_cart
          # shopping_item_id needs to be the original offer
          @shopping_item_id                 = @admin_customer_offer.id

          # create our new frozen_offer? record that no one can adjust picture
          @admin_customer_offer             = @admin_customer_offer.generate_for_cart

          # reset our info to the new frozen offer
          session[:admin_customer_offer_id] = @admin_customer_offer.id
          params[:shopping_item][:offer_id] = @admin_customer_offer.id
        end
      end

      params[:offer_id] = params[:shopping_item][:offer_id]
      params[:cart_id]  = params[:shopping_item][:cart_id]

      @storyline.describe "Adding #{@admin_customer_offer.name} to cart."

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
        attrs ={quantity: quantity}
        if params[:ring_size]
          attrs[:option]          = 'ring size'
          attrs[:option_selected] = params[:ring_size]
        end
        @item.update_attributes attrs
      end
      respond_to do |format|
        format.js { render(:update) }
      end
    end

  end
end