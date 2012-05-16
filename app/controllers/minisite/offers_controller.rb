module Minisite

  class OffersController < BaseController

    # GET /minisite/offers
    # GET /minisite/offers.json
    def index
      if @admin_customer_email
        @admin_customer_offers = @admin_customer_email.offers
      else
        @admin_customer_offers = Admin::Customer::Offer.where(:tracking => params[:email_id]).all
      end
      @shopping_item = Shopping::Item.new(:offer => @admin_customer_offer, :cart => @cart)
      @storyline.describe "Viewing offers page."
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @admin_customer_offers }
      end
    end

    # GET /minisite/offers/1t7t7rye
    # GET /minisite/offers/1t7t7rye.json
    def show
      @admin_customer_offer.update_attribute :visited_at, Time.now
      @shopping_item = Shopping::Item.new(:offer => @admin_customer_offer, :cart => @cart)
      @story.describe "Viewing offer #{@admin_customer_offer.name}"
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @admin_customer_offer }
      end
    end

    # GET /minisite/offers/new
    # GET /minisite/offers/new.json
    def new
      @admin_customer_offer = Admin::Customer::Offer.new(:email => @email)
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
      @admin_customer_offer       = Admin::Customer::Offer.new(params[:admin_customer_offer])
      @admin_customer_offer.email = @email
      respond_to do |format|
        if @admin_customer_offer.save
          format.html { redirect_to admin_customer_email_offer_url(@email, @admin_customer_offer), notice: 'Offer was successfully created.' }
          format.json { render json: admin_customer_email_offer_url(@email, @admin_customer_offer), status: :created, location: @admin_customer_offer }
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

  end

end