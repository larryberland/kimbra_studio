class StudiosController < ApplicationController

  before_filter :form_info
  before_filter :authenticate_admin!
  skip_before_filter :authenticate_user!,  only: [:unsubscribe]

  # GET /studios
  # GET /studios.json
  def index
    set = if params[:search_logoize].blank?
            if session[:search_logoize].blank?
              Studio.search(params[:search])
            else
              Studio.search_logoize(session[:search_logoize])
            end
          elsif params[:search_logoize] == 'any'
            session[:search_logoize] = 'any'
            Studio.search(params[:search])
          else
            session[:search_logoize] = params[:search_logoize]
            Studio.search_logoize(params[:search_logoize])
          end
    @logo_search_value = params[:search_logoize] || session[:search_logoize]
    @record_count = set.count
    @studios = set.page(params[:page])
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
    puts "params:#{params.inspect}"
    if current_user.admin?
      @studio = Studio.new(info:     MyStudio::Info.new,
                           minisite: MyStudio::Minisite.new)
      attrs = {first_pass: User.generate_random_text}
      attrs[:password] = attrs[:first_pass]
      @studio.build_owner(attrs)
    else
      @studio = Studio.new(info:     MyStudio::Info.new(email: current_user.email),
                           minisite: MyStudio::Minisite.new,
                           owner:    current_user)
    end
    @my_studio = @studio
    respond_to do |format|
      format.html
      format.json { render json: @studio }
    end
  end

  def new_owner
    @studio = Studio.find(params[:id])
    @studio.build_owner
  end

  # GET /studios/1/edit
  def edit
    @studio = Studio.find(params[:id])
  end

  # POST /studios
  # POST /studios.json
  def create
    owner_info = params[:studio].delete(:owner_attributes)
    @studio    = Studio.new(params[:studio])
    notice     = 'Studio was successfully created.'
    if current_user.admin?
      notice = 'Studio was successfully created with no owner.'
      if owner_info[:email].present?
        # create the user, make them owner, don't send email (yet)
        owner = User.new(owner_info.merge(password: owner_info[:first_pass]))
        owner.skip_confirmation!
        @studio.owner = owner
        notice        = 'Studio created with owner but no email sent.'
      end
    else
      @studio.owner        = User.find(owner_info[:id])
      @studio.current_user = current_user
    end
    respond_to do |format|
      if @studio.save
        format.html { redirect_to current_user.admin? ? studios_path : my_studio_minisite_path(@studio), notice: notice }
        format.json { render json: @studio, status: :created, location: @studio }
      else
        format.html { render action: "new" }
        format.json { render json: @studio.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_owner
    owner_info = params[:studio].delete(:owner_attributes)
    @studio    = Studio.find(params[:id])
    owner_info[:first_pass] = User.generate_random_text
    owner      = User.new(owner_info.merge(password: owner_info[:first_pass]))
    owner.skip_confirmation!
    respond_to do |format|
      if owner.save && @studio.owner = owner
        # TODO review these paths!
        format.html { redirect_to studios_path, notice: 'Studio owner created, but email not sent.' }
      else
        @studio.errors[:base] << owner.errors.full_messages
        @studio.build_owner(owner_info)
        format.html { render action: "new_owner" }
      end
    end
  end

  # PUT /studios/1
  # PUT /studios/1.json
  # Assumes only the studio owner will be updating here.
  def update
    @studio = Studio.find(params[:id])
    @studio.current_user = current_user unless current_user.admin?
    @studio.update_attributes(params[:studio])
    respond_to do |format|
      if @studio.save
        format.html { redirect_to my_studio_minisite_path(@studio), notice: "Studio was successfully updated." }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @studio.errors, status: :unprocessable_entity }
      end
    end
  end

  # Ajax action that sends email and returns text.
  def send_new_account_email
    studio   = Studio.find(params[:id])
    Notifier.delay.studio_eap_email(studio.id)
    respond_to do |format|
      format.js do
        render text: "$('#send_new_account_email_#{studio.id}').html('queueing email...').effect('highlight', 2000)"
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

  def show_branding
    @my_studio          = Studio.find(params[:id])
    @my_studio_minisite = @my_studio.minisite
    render 'my_studio/minisites/show'
  end

  def unsubscribe
    email = params[:email]
    if User.exists?(email: email)
      Unsubscribe.create(email: email) unless Unsubscribe.exists?(email: email)
      render 'minisite/emails/unsubscribe', layout: false
    else
      render(text: 'No email found with that email address.')
    end
  end

  private #==========================================================================

  def form_info
    @states = State.form_selector
  end

end