class Admin::Customer::EmailsController < ApplicationController

  before_filter :set_by_tracking
  before_filter :authenticate_admin!, only: [:edit, :create, :update, :destroy]

  # GET /admin/customer/emails
  # GET /admin/customer/emails.json
  def index
    @admin_customer_emails = Admin::Customer::Email.order('generated_at desc')
    @record_count          = @admin_customer_emails.count
    @admin_customer_emails = @admin_customer_emails.page(params[:page])

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

  def show_collection
    @studio = @my_studio
    render layout: false
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
    Admin::Customer::Email.delay.generate(params[:id].to_i)
    respond_to do |format|
      format.html { render :edit }
      format.js do
        render text: "$('#generate_email_#{params[:id]}').html('generating...').effect('highlight', 2000)"
      end
    end
  end

  def send_offers
    email = Admin::Customer::Email.find_by_tracking(params[:id])
    email.send_offers(email.offers.first)
    flash[:notice] = "Sending offer email to #{email.my_studio_session.client.name} from #{email.my_studio_session.studio.name}."
    redirect_to admin_overview_path
  end

  def send_all_offers
    Admin::Customer::Email.unsent.each do |email|
      email.send_offers
    end
    respond_to do |format|
      format.js do
        render text: "$('#send_all_emails').html('queueing all unsent emails...').effect('highlight', 2000)"
      end
    end
  end

  # GET /admin/customer/emails/session_id/session
          # GET /admin/customer/emails/session_id/session/.json
  def session_list
    @admin_customer_emails = Admin::Customer::Email.by_session(MyStudio::Session.find(params[:id]))
    @record_count = @admin_customer_emails.count
    @admin_customer_emails = @admin_customer_emails.page(params[:page])
    render :index
  end

  private #================================================

  def set_by_tracking
    @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:id]) if params[:id]
  end

end