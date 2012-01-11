class Studio::ClientsController < ApplicationController
  # GET /studio/clients
  # GET /studio/clients.json
  def index
    @studio_clients = Studio::Client.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @studio_clients }
    end
  end

  # GET /studio/clients/1
  # GET /studio/clients/1.json
  def show
    @studio_client = Studio::Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @studio_client }
    end
  end

  # GET /studio/clients/new
  # GET /studio/clients/new.json
  def new
    @studio_client = Studio::Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @studio_client }
    end
  end

  # GET /studio/clients/1/edit
  def edit
    @studio_client = Studio::Client.find(params[:id])
  end

  # POST /studio/clients
  # POST /studio/clients.json
  def create
    @studio_client = Studio::Client.new(params[:studio_client])

    respond_to do |format|
      if @studio_client.save
        format.html { redirect_to @studio_client, notice: 'Client was successfully created.' }
        format.json { render json: @studio_client, status: :created, location: @studio_client }
      else
        format.html { render action: "new" }
        format.json { render json: @studio_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /studio/clients/1
  # PUT /studio/clients/1.json
  def update
    @studio_client = Studio::Client.find(params[:id])

    respond_to do |format|
      if @studio_client.update_attributes(params[:studio_client])
        format.html { redirect_to @studio_client, notice: 'Client was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @studio_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studio/clients/1
  # DELETE /studio/clients/1.json
  def destroy
    @studio_client = Studio::Client.find(params[:id])
    @studio_client.destroy

    respond_to do |format|
      format.html { redirect_to studio_clients_url }
      format.json { head :ok }
    end
  end
end
