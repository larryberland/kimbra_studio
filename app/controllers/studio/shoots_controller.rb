class Studio::ShootsController < ApplicationController

  # GET /studio/shoots
  # GET /studio/shoots.json
  def index
    @studio_shoots = Studio::Shoot.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @studio_shoots }
    end
  end

  # GET /studio/shoots/1
  # GET /studio/shoots/1.json
  def show
    @studio_shoot = Studio::Shoot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @studio_shoot }
    end
  end

  # GET /studio/shoots/new
  # GET /studio/shoots/new.json
  def new
    @studio_shoot = Studio::Shoot.new
    @studio_shoot.studio = current_user.studio

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @studio_shoot }
    end
  end

  # GET /studio/shoots/1/edit
  def edit
    @studio_shoot = Studio::Shoot.find(params[:id])
  end

  # POST /studio/shoots
  # POST /studio/shoots.json
  def create
    @client = Studio::Client.new(params[:studio_shoot].delete(:client))
    @studio_shoot = Studio::Shoot.new(params[:studio_shoot])
    @studio_shoot.client = @client
    @studio_shoot.studio = current_user.studio

    respond_to do |format|
      if @studio_shoot.save
        format.html { redirect_to @studio_shoot, notice: 'Shoot was successfully created.' }
        format.json { render json: @studio_shoot, status: :created, location: @studio_shoot }
      else
        format.html { render action: "new" }
        format.json { render json: @studio_shoot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /studio/shoots/1
  # PUT /studio/shoots/1.json
  def update
    @studio_shoot = Studio::Shoot.find(params[:id])
    @studio_shoot.client.update_attributes(params[:studio_shoot].delete(:client))

    respond_to do |format|
      if @studio_shoot.update_attributes(params[:studio_shoot])
        format.html { redirect_to @studio_shoot, notice: 'Shoot was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @studio_shoot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studio/shoots/1
  # DELETE /studio/shoots/1.json
  def destroy
    @studio_shoot = Studio::Shoot.find(params[:id])
    @studio_shoot.destroy

    respond_to do |format|
      format.html { redirect_to studio_shoots_url }
      format.json { head :ok }
    end
  end
end
