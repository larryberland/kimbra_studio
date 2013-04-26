module Minisite
  class PortraitsController < BaseController

    layout 'minisite'

    # GET /minisite/emails/:id/portraits
    # GET /minisite/emails/:id/portraits.json
    def index
      @navbar_active       = :upload
      @my_studio_session   = @admin_customer_email.my_studio_session
      @my_studio_portraits = MyStudio::Portrait.where(my_studio_session_id: @my_studio_session).order('created_at desc')
      @record_count        = @my_studio_portraits.size
      @storyline.describe 'Viewing Upload Photos page.'
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @my_studio_portraits.collect { |p| p.to_jq_upload }.to_json }
      end
    end

    # GET /minisite/emails/:id/portraits/1
    # GET /minisite/emails/:id/portraits/1.json
    def show
      @my_studio_portrait = MyStudio::Portrait.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @my_studio_portrait }
      end
    end

    # NOT USED IN THIS CONTROLLER.
    def new
      @my_studio_portrait = MyStudio::Portrait.new(:my_studio_session => @my_studio_session)
      respond_to do |format|
        format.html
        format.js
      end
    end

    # GET /minisite/emails/:id/portraits/1/edit
    # NOT USED IN THIS CONTROLLER.
    def edit
      @my_studio_portrait = MyStudio::Portrait.find(params[:id])
    end

    # POST /minisite/emails/:id/portraits
    # POST /minisite/emails/:id/portraits.json
    def create
      @my_studio_session             = @admin_customer_email.my_studio_session
      p_attrs                        = params[:my_studio_portrait]
      p_attrs[:my_studio_session_id] = @my_studio_session.id
      p_attrs[:image] = params[:my_studio_portrait][:file].first if params[:my_studio_portrait][:file].class == Array
      @my_studio_portrait                   = MyStudio::Portrait.new(p_attrs)
      @my_studio_portrait.my_studio_session = @my_studio_session
      if @my_studio_portrait.save
        @storyline.describe 'Uploaded new photo.'
        respond_to do |format|
          format.html {
            render :json         => [@my_studio_portrait.to_jq_upload].to_json,
                   :content_type => 'text/html',
                   :layout       => false
          }
          format.json { render json: [@my_studio_portrait.to_jq_upload].to_json }
        end
      else
        render json: [{:error => "custom_failure"}], status: 304
      end
    end

    # PUT /minisite/emails/:id/portraits/1
    # PUT /minisite/emails/:id/portraits/1.json
    # NOT USED IN THIS CONTROLLER.
    def update
      @my_studio_portrait                   = MyStudio::Portrait.find(params[:id])
      @my_studio_portrait.my_studio_session = @my_studio_session
      respond_to do |format|
        if @my_studio_portrait.update_attributes(params[:my_studio_portrait])
          format.html { redirect_to my_studio_session_portraits_url(@my_studio_session), notice: 'Portrait was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @my_studio_portrait.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /minisite/emails/:id/portraits/1
    # DELETE /minisite/emails/:id/portraits/1.json
    # NOT USED IN THIS CONTROLLER.
    def destroy
      @my_studio_portrait = MyStudio::Portrait.find(params[:id])
      @my_studio_portrait.destroy
      @my_studio_portraits = MyStudio::Portrait.where(my_studio_session_id: @my_studio_session).order('created_at desc')
      @record_count        = @my_studio_portraits.size
      respond_to do |format|
        format.html { redirect_to my_studio_session_portraits_url }
        format.json { head :ok }
      end
    end

    private

    # override load_email
    #  currently the exact same as offers hoping to move this
    #  into minisite base
    def load_email_or_cart
      raise 'Portraits controller should always have an email_id' unless params.key?(:email_id)
      # TODO: in portraits we seem to have an id instead of tracking
      if "#{params[:email_id].to_i}" == params[:email_id]
        raise 'we should be using tracking not email_id'
        @admin_customer_email = Admin::Customer::Email.find_by_id(params[:email_id])
      else
        # tracking number
        if params[:email_id] == 'xyz'
          # new client without a studio to start building their own piece
          # create an email for this client to work with on the minisite
          now                   = Time.now
          owner                 = User.find_by_email(KIMBRA_STUDIO_CONFIG[:gypsy_studio][:email])
          gypsy_client          = MyStudio::Client.create!({name:  t('gypsy.client.name'),
                                                            email: t('gypsy.client.email')})
          attrs                 = {studio:  owner.studio,
                                   session: {studio:     owner.studio,
                                             name:       t('gypsy.session.name'),
                                             session_at: 10.minutes.ago(now),
                                             active:     true,
                                             category:   Category.find_by_name('Other'),
                                             client:     gypsy_client},
                                   email:   {generated_at: 5.minutes.ago(now),
                                             sent_at:      now}
          }
          @admin_customer_email = Admin::Customer::Email.create_gypsy(attrs)
          params[:email_id]     = @admin_customer_email.tracking
        else
          @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:email_id])
        end
      end
      raise "we should redirect to somewhere helpful looking for tracking:#{params[:email_id]}" if @admin_customer_email.nil?
      sync_session_email(@admin_customer_email)
    end

  end
end