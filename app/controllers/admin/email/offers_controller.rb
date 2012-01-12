class Admin::Email::OffersController < ApplicationController
  # GET /admin/email/offers
  # GET /admin/email/offers.json
  def index
    @admin_email_offers = Admin::Email::Offer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_email_offers }
    end
  end

  # GET /admin/email/offers/1
  # GET /admin/email/offers/1.json
  def show
    @admin_email_offer = Admin::Email::Offer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_email_offer }
    end
  end

  # GET /admin/email/offers/new
  # GET /admin/email/offers/new.json
  def new
    @admin_email_offer = Admin::Email::Offer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_email_offer }
    end
  end

  # GET /admin/email/offers/1/edit
  def edit
    @admin_email_offer = Admin::Email::Offer.find(params[:id])
  end

  # POST /admin/email/offers
  # POST /admin/email/offers.json
  def create
    @admin_email_offer = Admin::Email::Offer.new(params[:admin_email_offer])

    respond_to do |format|
      if @admin_email_offer.save
        format.html { redirect_to @admin_email_offer, notice: 'Offer was successfully created.' }
        format.json { render json: @admin_email_offer, status: :created, location: @admin_email_offer }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_email_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/email/offers/1
  # PUT /admin/email/offers/1.json
  def update
    @admin_email_offer = Admin::Email::Offer.find(params[:id])

    respond_to do |format|
      if @admin_email_offer.update_attributes(params[:admin_email_offer])
        format.html { redirect_to @admin_email_offer, notice: 'Offer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_email_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/email/offers/1
  # DELETE /admin/email/offers/1.json
  def destroy
    @admin_email_offer = Admin::Email::Offer.find(params[:id])
    @admin_email_offer.destroy

    respond_to do |format|
      format.html { redirect_to admin_email_offers_url }
      format.json { head :ok }
    end
  end
end
