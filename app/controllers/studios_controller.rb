class StudiosController < ApplicationController

  before_filter :form_info

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
    @studio           = Studio.new
    @studio.info      = MyStudio::Info.new(:email => current_user.email)
    @studio.mini_site = MyStudio::MiniSite.new
    @studio.owner     = current_user

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
    @my_studio_info      = MyStudio::Info.new(params[:studio].delete(:info))
    @my_studio_mini_site = MyStudio::MiniSite.new(params[:studio].delete(:mini_site))
    @studio              = Studio.new(params[:studio])
    @studio.info         = @my_studio_info
    @studio.mini_site    = @my_studio_mini_site
    @studio.owner        = current_user
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
    @studio = Studio.find(params[:id])

    @studio.info ||= MyStudio::Info.new()
    @studio.info.update_attributes(params[:studio].delete(:info))

    @studio.mini_site ||= MyStudio::MiniSite.new()
    @studio.mini_site.update_attributes(params[:studio].delete(:mini_site))

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

  private

  def form_info
    @states = State.form_selector
  end

end
