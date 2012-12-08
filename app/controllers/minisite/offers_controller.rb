module Minisite

  class OffersController < BaseController

    # GET /minisite/offers
    # GET /minisite/offers.json
    def index
      if @admin_customer_email
        @admin_customer_email.update_attribute(:visited_at, Time.now) if is_client?
        @admin_customer_offers = @admin_customer_email.offers
      else
        @admin_customer_offers = Admin::Customer::Offer.where(:tracking => params[:email_id]).all
      end
      @shopping_item = Shopping::Item.new(:offer => @admin_customer_offer, :cart => @cart)
      @storyline.describe 'Viewing collection page.'
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @admin_customer_offers }
      end
    end

    # GET /minisite/index_charms
    # GET /minisite/index_charms.json
    def index_charms
      if @admin_customer_email
        @admin_customer_email.update_attribute(:visited_at, Time.now) if is_client?
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
      if @admin_customer_email
        @admin_customer_email.update_attribute(:visited_at, Time.now) if is_client?
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
      @admin_customer_offer.update_attribute(:visited_at, Time.now) if is_client?
      @shopping_item = Shopping::Item.new(:offer => @admin_customer_offer, :cart => @cart)
      @storyline.describe "Viewing #{@admin_customer_offer.name} offer."
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @admin_customer_offer }
      end
    end

    # GET /minisite/offers/new
    # GET /minisite/offers/new.json
    def new
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
      @admin_customer_offer       = Admin::Customer::Offer.new(params[:admin_customer_offer])
      @admin_customer_offer.email = @admin_customer_email

      result = @admin_customer_offer.save
      @admin_customer_offer.on_create if result

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
      @admin_customer_offer.email = @email
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
      @admin_customer_offer.destroy
      respond_to do |format|
        format.html { redirect_to admin_customer_offers_url }
        format.json { head :ok }
      end
    end

    # get /minisite/offers/tracking/portrait
    def portrait
      @portrait = MyStudio::Portrait.find(params[:portrait_id]) rescue nil
    end

    def share
      if @admin_customer_offer
        if (current_user_facebook)
          current_user_facebook.share(@admin_customer_offer)
        end
      end
    end
  end

end