module Minisite

  class OffersController < BaseController

    before_filter :set_visited_at_email, only: [:index, :index_custom, :index_friends, :index_chains, :index_charms]
    before_filter :set_visited_at_offer, only: [:show]
    before_filter :reap_friends, only: [:index]

    # GET /minisite/offers
    # GET /minisite/offers.json
    def index
      @navbar_active = :suggestions
      if @admin_customer_email
        @admin_customer_offers = @admin_customer_email.offers_by_suggestions
      else
        @admin_customer_offers = Admin::Customer::Offer.where(:tracking => params[:email_id]).all
      end
      @storyline.describe 'Viewing collection page.'
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @admin_customer_offers }
      end
    end

    # GET /minisite/index_custom
    # GET /minisite/index_custom.json
    def index_custom
      session[:index_customs] = {friend_id: @admin_customer_friend.id} if @admin_customer_friend
      if @admin_customer_email
        raise "should always have a friend here? email:#{@admin_customer_email.inspect}" unless @admin_customer_friend.present?
        @admin_customer_offers = @admin_customer_email.offers_by_collection(@admin_customer_friend.id)
      else
        @admin_customer_offers = Admin::Customer::Offer.where(:tracking => params[:email_id]).all
      end
      if (@admin_customer_offers.size > 0)
        @storyline.describe 'Viewing friends collection page.'
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @admin_customer_offers }
        end
      else
        # redirect to offers#new
        @storyline.describe 'Viewing friends collection page, redirecting to Build a Piece'
        flash[:notice] = t('minisite.offers.index_custom.redirect_to_build_a_piece_html')
        redirect_to new_minisite_email_offer_path(@admin_customer_email)
      end
    end

    # GET /minisite/index_friends
    # GET /minisite/index_friends.json
    def index_friends
      @friend = Admin::Customer::Friend.find_by_id(params[:friend])
      if @friend.present?
        session[:index_friends] = {friend_id: @friend.id}
        @navbar_active = "friend_#{@friend.id}".to_sym
      end
      raise "index_friend should always have a friend here? email:#{@admin_customer_email.inspect}" unless @friend.present?
      if @admin_customer_email
        @admin_customer_offers = @admin_customer_email.offers_by_friend(@friend.id)
      else
        @admin_customer_offers = Admin::Customer::Offer.where(:tracking => params[:email_id]).all
      end
      # LDB:? Changed this to offers.first it was @admin_customer_offer
      if (@admin_customer_offers.size > 0)
        @storyline.describe 'Viewing friends collection page.'
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @admin_customer_offers }
        end
      else
        # redirect to offers#new
        @storyline.describe 'Viewing friends collection page. Redirecting to Build a Piece.'
        redirect_to new_minisite_email_offer_path(@admin_customer_email)
      end
    end

    # GET /minisite/index_charms
    # GET /minisite/index_charms.json
    def index_charms
      @navbar_active = :charms
      if @admin_customer_email
        @admin_customer_offers = @admin_customer_email.offers
      else
        @admin_customer_offers = Admin::Customer::Offer.where(:tracking => params[:email_id]).all
      end
      # only show charms that have not already been added to their offers page
      existing_offers = @admin_customer_offers.collect { |r| r.piece.id }
      @pieces         = Admin::Merchandise::Piece.non_photo_charms.all.select { |p| !existing_offers.include?(p.id) }
      @shopping_item = Shopping::Item.new(:offer => @admin_customer_offer, :cart => @cart)
      @storyline.describe 'Viewing charms page.'
      respond_to do |format|
        format.html # index_charms.html.erb
        format.json { render json: @admin_customer_offers }
      end
    end

    # GET /minisite/index_chains
    # GET /minisite/index_chains.json
    def index_chains
      @navbar_active = :chains
      if @admin_customer_email
        @admin_customer_offers = @admin_customer_email.offers
      else
        @admin_customer_offers = Admin::Customer::Offer.where(:tracking => params[:email_id]).all
      end
      # only show charms that have not already been added to their offers page
      existing_offers = @admin_customer_offers.collect { |r| r.piece.id }
      @pieces         = Admin::Merchandise::Piece.for_chains.all.select { |p| !existing_offers.include?(p.id) }

      @shopping_item = Shopping::Item.new(:offer => @admin_customer_offer, :cart => @cart)
      @storyline.describe 'Viewing chains page.'
      respond_to do |format|
        format.html # index_charms.html.erb
        format.json { render json: @admin_customer_offers }
      end
    end

    # GET /minisite/offers/1t7t7rye
    # GET /minisite/offers/1t7t7rye.json
    def show
      @shopping_item = Shopping::Item.new(offer: @admin_customer_offer, cart: @cart)
      @storyline.describe "Viewing #{@admin_customer_offer.name} offer."
      @navbar_active = :suggestions if (@admin_customer_offer.suggestion?)
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @admin_customer_offer }
      end
    end

    # GET /minisite/offers/new
    # GET /minisite/offers/new.json
    def new
      @navbar_active = :create_custom
      @storyline.describe "New email offer #{@admin_customer_email.my_studio_session.client.email}"
      @admin_customer_offer = Admin::Customer::Offer.new(email: @admin_customer_email)
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @admin_customer_offer }
      end
    end

    # GET /minisite/offers/1t7t7rye/edit
    def edit
      @storyline.describe "Editing offer #{@admin_customer_offer.name}"
    end

    # POST /minisite/offers
    # POST /minisite/offers.json
    def create
      # LDB: Changing this pretty sure this was just copied
      #      from admin_customer_offers
      # sure seems like i need a generate here with the portrait etc...

      params[:admin_customer_offer][:client] = is_client?

      pieces = params[:admin_customer_offer].delete(:pieces)

      attrs = params[:admin_customer_offer]
      attrs[:email] = @admin_customer_email # attach the email from the incoming_request tracking_number

      # in case the create fails then redirect will have an offer object
      @admin_customer_offer = Admin::Customer::Offer.new(attrs)

      result = false
      if (pieces)

        piece_ids = pieces.collect{|category_tag, piece_info| piece_info[:piece_id].to_i}.select{|r| r > 0}

        if piece_ids.present?

          # create the first one in real-time
          attrs[:piece_id] = piece_ids.shift
          @admin_customer_offer = Admin::Customer::Offer.create(attrs)
          result = @admin_customer_offer.on_create
          @storyline.describe "Created new offer #{@admin_customer_offer.name}." if @admin_customer_offer

          # delay the other offer pieces
          piece_ids.each do |piece_id|
            attrs[:piece_id] = piece_id
            offer = Admin::Customer::Offer.create(attrs)
            offer.delay.on_create_delay(attrs[:portrait_id])
          end
        end
      end

      respond_to do |format|
        if result
          url = if @admin_customer_offer.has_picture?
                  if @admin_customer_offer.items.size > 1
                    minisite_offer_items_path(@admin_customer_offer)
                  else
                    edit_minisite_item_side_path(@admin_customer_offer.items.first.front)
                  end
                else
                  minisite_email_offer_url(@admin_customer_email, @admin_customer_offer)
                end
          format.html { redirect_to url, notice: t(:minisite_offers_create_success) }
          format.json { render json: minisite_email_offer_url(@admin_customer_email, @admin_customer_offer), status: :created, location: @admin_customer_offer }
        else
          format.html { render action: "new" }
          format.json { render json: @admin_customer_offer.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /minisite/offers/1t7t7rye
    # PUT /minisite/offers/1t7t7rye.json
    def update
      params[:admin_customer_offer][:client] = is_client?
      @admin_customer_offer.email = @email
      @storyline.describe "Updated offer #{@admin_customer_offer.name}."
      respond_to do |format|
        if @admin_customer_offer.update_attributes(params[:admin_customer_offer])
          format.html { redirect_to admin_customer_email_offer_url(@email, @admin_customer_offer), notice: 'Offer was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @admin_customer_offer.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /minisite/offers/1t7t7rye
    # DELETE /minisite/offers/1t7t7rye.json
    def destroy
      @storyline.describe "Deleted offer #{@admin_customer_offer.name}."
      if (@cart)
        if item = @cart.find_item(@admin_customer_offer.id)
          item.destroy
        end
      end
      @admin_customer_offer.destroy
      respond_to do |format|
        format.html { redirect_to admin_customer_offers_url }
        format.json { head :ok }
        format.js
      end
    end

    # get /minisite/offers/tracking/portrait
    def portrait
      @storyline.describe "Fetch portrait."
      @portrait = MyStudio::Portrait.find(params[:portrait_id]) rescue nil
    end

    # TODO - currently linking to Collection - change to link to just the offer.
    def share
      @storyline.describe "Sharing offer #{@admin_customer_offer.name} on Facebook."
      if @admin_customer_offer
        if current_user_facebook
          current_user_facebook.share(@admin_customer_offer, minisite_email_offers_url(@admin_customer_offer.email))
        end
      end
    end

    private #===================================================================

    def set_visited_at_email
      if @admin_customer_email and is_client?
        @admin_customer_email.update_attribute(:visited_at, Time.now)
      end
    end

    def set_visited_at_offer
      if @admin_customer_offer and is_client?
        @admin_customer_offer.update_attribute(:visited_at, Time.now)
      end
    end

    def reap_friends
      # some friends for this email may not have any offers in them
      #   so reclaim the names to be used by others
      @admin_customer_email.reap_friends if @admin_customer_email
    end
  end

end