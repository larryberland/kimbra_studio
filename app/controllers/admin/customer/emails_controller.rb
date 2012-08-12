class Admin::Customer::EmailsController < ApplicationController

  before_filter :set_by_tracking

  # GET /admin/customer/emails
  # GET /admin/customer/emails.json
  def index
    @admin_customer_emails = Admin::Customer::Email.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_customer_emails }
    end
  end

  # GET /admin/customer/emails/1at673tyay
  # GET /admin/customer/emails/1at673tyay.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_customer_email }
    end
  end

  # GET /admin/customer/emails/new
  # GET /admin/customer/emails/new.json
  def new
    @admin_customer_email = Admin::Customer::Email.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_customer_email }
    end
  end

  # GET /admin/customer/emails/1s6s5e5d/edit
  def edit

  end

  # POST /admin/customer/emails
  # POST /admin/customer/emails.json
  def create
    @admin_customer_email = Admin::Customer::Email.new(params[:admin_customer_email])
    respond_to do |format|
      if @admin_customer_email.save
        format.html { redirect_to @admin_customer_email, notice: 'Email was successfully created.' }
        format.json { render json: @admin_customer_email, status: :created, location: @admin_customer_email }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_customer_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/customer/emails/1at673tyay
  # PUT /admin/customer/emails/1at673tyay.json
  def update
    respond_to do |format|
      if @admin_customer_email.update_attributes(params[:admin_customer_email])
        format.html { redirect_to @admin_customer_email, notice: 'Email was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_customer_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/customer/emails/1at673tyay
  # DELETE /admin/customer/emails/1at673tyay.json
  def destroy
    @admin_customer_email = Admin::Customer::Email.find(params[:id])
    @admin_customer_email.destroy
    respond_to do |format|
      format.html { redirect_to admin_customer_emails_url }
      format.json { head :ok }
    end
  end

  # GET /admin/customer/emails/session_id/generate
  # GET /admin/customer/emails/session_id/generate/.json
  def generate
    puts "Generate params=>#{params.inspect}"
    @admin_customer_email = Admin::Customer::Email.delay.generate(params[:id])
    respond_to do |format|
      format.html { render :edit }
      format.js do
        render text: "$('#generate_email_#{params[:id]}').html('generating...')"
      end
    end
  end

  def send_offers
    Admin::Customer::Email.find(params[:id]).send_offers
    render text: 'email will be sent soon'
  end

  # GET /admin/customer/emails/session_id/session
  # GET /admin/customer/emails/session_id/session/.json
  def session_list
    puts "Session params=>#{params.inspect}"
    @admin_customer_emails = Admin::Customer::Email.by_session(MyStudio::Session.find(params[:id])).all
    render :index
  end

  private #================================================

  def set_by_tracking
    @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id]) if params[:id]
  end

end