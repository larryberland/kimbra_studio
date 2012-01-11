class StudiosController < ApplicationController
  # GET /studios
  # GET /studios.json
  def index
    @studios = Studio.all

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
    @studio = Studio.new

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
    @info_studio = InfoStudio.new(params[:studio].delete(:info_studio))
    @studio      = Studio.new(params[:studio])
    @studio.info_studio = @info_studio if @info_studio
    @studio.current_user = current_user

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
    @studio      = Studio.find(params[:id])
    @info_studio = InfoStudio.new(params[:studio].delete(:info_studio))
    @studio.info_studio = @info_studio if @info_studio
    @studio.current_user = current_user

    respond_to do |format|
      if @studio.update_attributes(params[:studio])
        format.html { redirect_to @studio, notice: 'Studio was successfully updated.' }
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
end
