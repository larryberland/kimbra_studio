class MyStudio::InfosController < MyStudio::BaseController
  # GET /my_studio/infos
  # GET /my_studio/infos.json
  def index
    @my_studio_infos = MyStudio::Info.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @my_studio_infos }
    end
  end

  # GET /my_studio/infos/1
  # GET /my_studio/infos/1.json
  def show
    @my_studio_info = MyStudio::Info.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_info }
    end
  end

  # GET /my_studio/infos/new
  # GET /my_studio/infos/new.json
  def new
    @my_studio_info = MyStudio::Info.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @my_studio_info }
    end
  end

  # GET /my_studio/infos/1/edit
  def edit
    @my_studio_info = MyStudio::Info.find(params[:id])
  end

  # POST /my_studio/infos
  # POST /my_studio/infos.json
  def create
    @my_studio_info = MyStudio::Info.new(params[:my_studio_info])

    respond_to do |format|
      if @my_studio_info.save
        format.html { redirect_to @my_studio_info, notice: 'Info was successfully created.' }
        format.json { render json: @my_studio_info, status: :created, location: @my_studio_info }
      else
        format.html { render action: "new" }
        format.json { render json: @my_studio_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /my_studio/infos/1
  # PUT /my_studio/infos/1.json
  def update
    @my_studio_info = MyStudio::Info.find(params[:id])

    respond_to do |format|
      if @my_studio_info.update_attributes(params[:my_studio_info])
        format.html { redirect_to @my_studio_info, notice: 'Info was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @my_studio_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_studio/infos/1
  # DELETE /my_studio/infos/1.json
  def destroy
    @my_studio_info = MyStudio::Info.find(params[:id])
    @my_studio_info.destroy

    respond_to do |format|
      format.html { redirect_to my_studio_infos_url }
      format.json { head :ok }
    end

    def samples
      # Static images of various pages.
      # TODO must make these dynamic so they look custom to the studio.
    end

  end
end