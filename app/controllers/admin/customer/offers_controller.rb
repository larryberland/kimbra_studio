class Admin::Customer::OffersController < ApplicationController

  before_filter :load_email
  before_filter :set_by_tracking
  skip_filter :authenticate_user!, only: :update_sort

  # GET /admin/customer/offers
  # GET /admin/customer/offers.json
  def index
    @email = Admin::Customer::Email.find_by_tracking(params[:email_id]) if @email.nil?
    @admin_customer_offers = @email.offers
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_customer_offers }
    end
  end

  # GET /admin/customer/offers/1t7t7rye
  # GET /admin/customer/offers/1t7t7rye.json
  def show
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

  # GET /admin/customer/offers/1t7t7rye/edit
  def edit

  end

  # POST /admin/customer/offers
  # POST /admin/customer/offers.json
  def create
    @admin_customer_offer       = Admin::Customer::Offer.new(params[:admin_customer_offer])
    @admin_customer_offer.email = @email
    result = @admin_customer_offer.save
    @admin_customer_offer.on_create if result
    respond_to do |format|
      if result
        format.html { redirect_to admin_customer_email_offers_url(@email), notice: 'Offer was successfully created.' }
        format.json { render json: admin_customer_email_offer_url(@email, @admin_customer_offer), status: :created, location: @admin_customer_offer }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_customer_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/customer/offers/1t7t7rye
  # PUT /admin/customer/offers/1t7t7rye.json
  def update
    @admin_customer_offer.email = @email
    previous_piece_id = @admin_customer_offer.piece_id
    if result = @admin_customer_offer.update_attributes(params[:admin_customer_offer])
      # send this to the worker to generate a new offer
      #   using the new kimbra piece
      @admin_customer_offer.on_update(previous_piece_id)
      # recreate our offer image versions in fog
      #Admin::Customer::Offer.fog_buster(@admin_customer_offer.id)
    end
    respond_to do |format|
      if result
        format.html { redirect_to admin_customer_email_offers_url(@email), notice: 'Offer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_customer_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/customer/offers/1t7t7rye
          # DELETE /admin/customer/offers/1t7t7rye.json
  def destroy
    email = @admin_customer_offer.email
    @admin_customer_offer.destroy
    email.reorder_offers!
    respond_to do |format|
      format.html { redirect_to admin_customer_email_offers_url(@email) }
      format.json { head :ok }
    end
  end

  def update_sort
    # "id"=>"115", "fromPosition"=>"3", "toPosition"=>"0"
    offer = Admin::Customer::Offer.find(params[:id])
    offer.update_sort_position(params['fromPosition'], params['toPosition'])
    render json: {head: :ok}
  rescue Exception => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    render json: {head: :not_ok}
  end

  private #===========================================================================

  def load_email
    @email = Admin::Customer::Email.find_by_tracking(params[:email_id]) if params[:email_id]
  end

  def set_by_tracking
    @admin_customer_offer = Admin::Customer::Offer.find_by_tracking(params[:id]) if params[:id]
  end

end