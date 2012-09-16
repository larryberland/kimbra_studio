class MyStudio::MinisitesController < MyStudio::BaseController

  # GET /my_studio/minisites
  # GET /my_studio/minisites.json
  def index
    @my_studio_minisites = MyStudio::Minisite.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @my_studio_minisites }
    end
  end

  # GET /my_studio/minisites/1
  # GET /my_studio/minisites/1.json
  def show
    @my_studio_minisite = MyStudio::Minisite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_minisite }
    end
  end

  # GET /my_studio/minisites/new
  # GET /my_studio/minisites/new.json
  def new
    @my_studio_minisite = MyStudio::Minisite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @my_studio_minisite }
    end
  end

  # GET /my_studio/minisites/1/edit
  def edit
    @my_studio_minisite = MyStudio::Minisite.find(params[:id])
  end

  # POST /my_studio/minisites
  # POST /my_studio/minisites.json
  def create
    @my_studio_minisite = MyStudio::Minisite.new(params[:my_studio_minisite])

    respond_to do |format|
      if @my_studio_minisite.save
        format.html { redirect_to @my_studio_minisite, notice: 'Mini site was successfully created.' }
        format.json { render json: @my_studio_minisite, status: :created, location: @my_studio_minisite }
      else
        format.html { render action: "new" }
        format.json { render json: @my_studio_minisite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /my_studio/minisites/1
  # PUT /my_studio/minisites/1.json
  def update
    @my_studio_minisite = MyStudio::Minisite.find(params[:id])

    respond_to do |format|
      if @my_studio_minisite.update_attributes(params[:my_studio_minisite])
        format.html { redirect_to @my_studio_minisite, notice: 'Mini site was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @my_studio_minisite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_studio/minisites/1
  # DELETE /my_studio/minisites/1.json
  def destroy
    @my_studio_minisite = MyStudio::Minisite.find(params[:id])
    @my_studio_minisite.destroy

    respond_to do |format|
      format.html { redirect_to my_studio_minisites_url }
      format.json { head :ok }
    end
  end

end