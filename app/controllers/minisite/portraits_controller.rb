module Minisite
  class PortraitsController < BaseController

    layout 'minisite'

    # GET /minisite/emails/:id/portraits
    # GET /minisite/emails/:id/portraits.json
    def index
      @navbar_active = :upload
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

  end
end