class Studio::PicturesController < ApplicationController
  before_filter :load_shoot

  # GET /studio/pictures
  # GET /studio/pictures.json
  def index
    @studio_pictures = Studio::Picture.where('shoot_id=?', params[:shoot_id]).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @studio_pictures }
    end
  end

  # GET /studio/pictures/1
  # GET /studio/pictures/1.json
  def show
    @studio_picture = Studio::Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @studio_picture }
    end
  end

  # GET /studio/pictures/new
  # GET /studio/pictures/new.json
  def new
    @studio_picture = Studio::Picture.new(:shoot => @shoot)
    @studio_picture.active = true

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @studio_picture }
    end
  end

  # GET /studio/pictures/1/edit
  def edit
    @studio_picture = Studio::Picture.find(params[:id])
  end

  # POST /studio/pictures
  # POST /studio/pictures.json
  def create
    @studio_picture       = Studio::Picture.new(params[:studio_picture])
    @studio_picture.shoot = @shoot

    respond_to do |format|
      if @studio_picture.save
        format.html { redirect_to studio_shoot_picture_url(@shoot, @studio_picture), notice: 'Picture was successfully created.' }
        format.json { render json: studio_shoot_picture_url(@shoot, @studio_picture), status: :created, location: @studio_picture }
      else
        format.html { render action: "new" }
        format.json { render json: @studio_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /studio/pictures/1
  # PUT /studio/pictures/1.json
  def update
    @studio_picture       = Studio::Picture.find(params[:id])
    @studio_picture.shoot = @shoot

    respond_to do |format|
      if @studio_picture.update_attributes(params[:studio_picture])
        format.html { redirect_to studio_shoot_picture_url(@shoot, @studio_picture), notice: 'Picture was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @studio_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studio/pictures/1
  # DELETE /studio/pictures/1.json
  def destroy
    @studio_picture = Studio::Picture.find(params[:id])
    @studio_picture.destroy

    respond_to do |format|
      format.html { redirect_to studio_shoot_pictures_url(@shoot) }
      format.json { head :ok }
    end
  end

  private

  def load_shoot
    @shoot = Shoot.find(params[:shoot_id]) if params[:shoot_id]
    puts "shoot=>#{@shoot}"
    @shoot
  end

end
