class MyStudio::ClientsController < MyStudio::BaseController
  # GET /my_studio/clients
  # GET /my_studio/clients.json
  def index
    @my_studio_clients = MyStudio::Client.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @my_studio_clients }
    end
  end

  # GET /my_studio/clients/1
  # GET /my_studio/clients/1.json
  def show
    @my_studio_client = MyStudio::Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_client }
    end
  end

  # GET /my_studio/clients/new
  # GET /my_studio/clients/new.json
  def new
    @my_studio_client = MyStudio::Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @my_studio_client }
    end
  end

  # GET /my_studio/clients/1/edit
  def edit
    @my_studio_client = MyStudio::Client.find(params[:id])
  end

  # POST /my_studio/clients
  # POST /my_studio/clients.json
  def create
    @my_studio_client = MyStudio::Client.new(params[:my_studio_client])

    respond_to do |format|
      if @my_studio_client.save
        format.html { redirect_to @my_studio_client, notice: 'Client was successfully created.' }
        format.json { render json: @my_studio_client, status: :created, location: @my_studio_client }
      else
        format.html { render action: "new" }
        format.json { render json: @my_studio_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /my_studio/clients/1
  # PUT /my_studio/clients/1.json
  def update
    @my_studio_client = MyStudio::Client.find(params[:id])

    respond_to do |format|
      if @my_studio_client.update_attributes(params[:my_studio_client])
        format.html { redirect_to @my_studio_client, notice: 'Client was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @my_studio_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_studio/clients/1
  # DELETE /my_studio/clients/1.json
  def destroy
    @my_studio_client = MyStudio::Client.find(params[:id])
    @my_studio_client.destroy

    respond_to do |format|
      format.html { redirect_to my_studio_clients_url }
      format.json { head :ok }
    end
  end
end
