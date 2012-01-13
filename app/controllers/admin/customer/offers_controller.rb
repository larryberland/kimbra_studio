class Admin::Customer::OffersController < ApplicationController
  before_filter :load_email

  # GET /admin/customer/offers
  # GET /admin/customer/offers.json
  def index
    @admin_customer_offers = Admin::Customer::Offer.where('email_id=?', params[:email_id]).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_customer_offers }
    end
  end

  # GET /admin/customer/offers/1
  # GET /admin/customer/offers/1.json
  def show
    @admin_customer_offer = Admin::Customer::Offer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_customer_offer }
    end
  end

  # GET /admin/customer/offers/new
  # GET /admin/customer/offers/new.json
  def new
    @admin_customer_offer = Admin::Customer::Offer.new(:email => @email)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_customer_offer }
    end
  end

  # GET /admin/customer/offers/1/edit
  def edit
    @admin_customer_offer = Admin::Customer::Offer.find(params[:id])
  end

  # POST /admin/customer/offers
  # POST /admin/customer/offers.json
  def create
    @admin_customer_offer = Admin::Customer::Offer.new(params[:admin_customer_offer])
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

  # PUT /admin/customer/offers/1
  # PUT /admin/customer/offers/1.json
  def update
    @admin_customer_offer = Admin::Customer::Offer.find(params[:id])
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

  # DELETE /admin/customer/offers/1
  # DELETE /admin/customer/offers/1.json
  def destroy
    @admin_customer_offer = Admin::Customer::Offer.find(params[:id])
    @admin_customer_offer.destroy

    respond_to do |format|
      format.html { redirect_to admin_customer_offers_url }
      format.json { head :ok }
    end
  end

  private

  def load_email
    @email = Admin::Customer::Email.find(params[:email_id]) if params[:email_id]
  end

end
