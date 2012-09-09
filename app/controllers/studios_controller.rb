class StudiosController < ApplicationController

  before_filter :form_info

  # GET /studios
  # GET /studios.json
  def index
    @studios      = Studio.order('updated_at desc, name asc')
    @record_count = @studios.count
    @studios      = @studios.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @studios }
    end
  end

  # GET /studios/1
  # GET /studios/1.json
  def show
    @studio = Studio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @studio }
    end
  end

  # GET /studios/new
  # GET /studios/new.json
  def new
    @studio       = Studio.new(info:     MyStudio::Info.new(:email => current_user.email),
                               minisite: MyStudio::Minisite.new)
    @studio.owner = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @studio }
    end
  end

  # GET /studios/1/edit
  def edit
    @studio = Studio.find(params[:id])
  end

  # POST /studios
  # POST /studios.json
  def create
    # coming from admin or new user this may be different
    owner_info           = params[:studio].delete(:owner_attributes)
    @studio              = Studio.new(params[:studio])
    @studio.owner        = User.find(owner_info[:id])
    # little concerned about using current_user here
    #   when Admin Creates Studio probably don't want current_user
    # @studio.current_user = current_user
    respond_to do |format|
      if @studio.save
        format.html { redirect_to @studio, notice: 'Studio was successfully created.' }
        format.json { render json: @studio, status: :created, location: @studio }
      else
        format.html { render action: "new" }
        format.json { render json: @studio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /studios/1
  # PUT /studios/1.json
  def update
    @studio = Studio.find(params[:id])
    @studio.update_attributes(params[:studio])
    email = params[:studio][:info_attributes][:email]
    # @studio.current_user = current_user
    # Create new owner user if the studio email was just added and we don't have that user already created.
    if email && !User.exists?(email: email) && @studio.owner.blank?
      password = User.generate_random_text
        owner = User.new(email: email, password: password, first_name: params[:first_name], last_name: params[:last_name])
        owner.skip_confirmation!
        @studio.owner = owner
        Notifier.delay.studio_signup_confirmation(@studio.id, email, password)
    end
    respond_to do |format|
      if @studio.save
        format.html { redirect_to @studio, notice: "Studio was successfully updated. #{ ('Confirmation email sent to ' + email) if email.present? }" }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @studio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studios/1
  # DELETE /studios/1.json
  def destroy
    @studio = Studio.find(params[:id])
    @studio.destroy

    respond_to do |format|
      format.html { redirect_to studios_url }
      format.json { head :ok }
    end
  end

  private #==========================================================================

  def form_info
    @states = State.form_selector
  end

end