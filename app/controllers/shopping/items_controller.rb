module Shopping
  class ItemsController < BaseController

    belongs_to :cart,
               :parent_class => Shopping::Cart,
               finder:       :find_by_tracking

    #belongs_to :offer,
    #           :parent_class => Admin::Customer::Offer
    respond_to :js, :only => [:create, :destroy]

    def new
      new!
    end

    def create
      # convert our nested form params
      piece_id          = params[:shopping_item].delete(:piece_id)
      # ajax unique id for <span> and <spinner>
      @shopping_item_id = piece_id.nil? ? params[:shopping_item][:offer_id] : piece_id
      item_already_in_cart = @cart.find_item(@admin_customer_offer.id) if @admin_customer_offer
      @create_notice = item_already_in_cart ? :add_to_cart : :add_to_collection
      # setup offer attributes in case we have to create a new offer
      offer_attrs    = {email:        @admin_customer_email,
                        friend:       @admin_customer_friend,
                        client:       is_client?,
                        frozen_offer: true}
      raise "have no shopping item? params:#{params.inspect}" if Rails.env.development? and params[:shopping_item].nil?
      if piece_id
        # Someone has picked one of the Kimbra Pieces that is not associated
        #   with our email offer (ex. chains or charms)
        # create an offer from this kimbra_piece and add to the shopping cart
        offer_attrs[:piece]   = Admin::Merchandise::Piece.find(piece_id)
        @admin_customer_offer = Admin::Customer::Offer.generate_from_piece(offer_attrs)
      else
        # sending an offer that has been adjusted and going to the shopping cart
        #   make a copy that is frozen and no one can edit in case they decide
        #   to purchase this offer
        unless item_already_in_cart
          # shopping_item_id needs to be the original offer
          # create our new frozen_offer? record that no one can adjust picture
          if in_my_collection?(@admin_customer_offer)
            # freeze this offer and add this to cart
            @admin_customer_offer.update_attributes(frozen_offer: true)
            @create_notice = :add_to_cart
          else
            # generate one for my collection
            @admin_customer_offer = @admin_customer_offer.generate_for_cart(offer_attrs)
          end
        end
      end
      # reset the offer_id in case we created a new offer item for the client
      params[:shopping_item][:offer_id] = @admin_customer_offer.id
      # set our session offer LDB:? Not sure why we ae setting this session info here
      session[:admin_customer_offer_id] = @admin_customer_offer.id
      @storyline.describe "Added #{@admin_customer_offer.name} to cart."
      if item_already_in_cart
        item_already_in_cart.update_attribute :quantity, item_already_in_cart.quantity.to_i + 1
        @item = item_already_in_cart
      else
        create!
      end
    end

    def update
      @item = Shopping::Item.find(params[:id]) rescue Shopping::Item.new
      quantity = params[:quantity].to_i
      @storyline.describe "Changed quantity of #{@item.try(:offer).try(:name)} to #{quantity} in cart."
      if quantity == 0
        # destroy any offers that came from charms/chains
        if offer = @item.offer
          offer.update_attributes(frozen_offer: false)
          if (Rails.env.development? and (!in_my_collection?(offer)))
            Rails.logger.info "setting offer that is not in my collection offer:#{offer.inspect}"
          end
        end
        @item.destroy
        session[:admin_customer_offer_id] = nil if session[:admin_customer_offer_id]
      else
        attrs = {quantity:        params[:quantity],
                 option:          params[:option],
                 option_selected: params[:option_selected]}
        @item.update_attributes attrs
      end
      respond_to do |format|
        format.js { render(:update) }
      end
    end

  end
end