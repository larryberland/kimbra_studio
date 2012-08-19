class MyStudio::PortraitsController < MyStudio::BaseController

  before_filter :load_my_studio_session

  # GET /my_studio/portraits
  # GET /my_studio/portraits.json
  def index
    @my_studio_portraits = MyStudio::Portrait.where('my_studio_session_id=?', @my_studio_session).order('created_at desc')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @my_studio_portraits }
    end
  end

  # GET /my_studio/portraits/1
  # GET /my_studio/portraits/1.json
  def show
    @my_studio_portrait = MyStudio::Portrait.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_portrait }
    end
  end

  def new
    @my_studio_portrait = MyStudio::Portrait.new(:my_studio_session => @my_studio_session)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /my_studio/portraits/1/edit
  def edit
    @my_studio_portrait = MyStudio::Portrait.find(params[:id])
  end

  # POST /my_studio/portraits
  # POST /my_studio/portraits.json
  def create
    @my_studio_portrait = MyStudio::Portrait.new(params[:my_studio_portrait])
    @my_studio_portrait.my_studio_session = @my_studio_session

    respond_to do |format|
      if @my_studio_portrait.save
        format.html { redirect_to my_studio_session_portraits_url(@my_studio_session), notice: 'Portrait was successfully created.' }
        format.json { render json: my_studio_session_portrait_url(@my_studio_session, @my_studio_portrait), status: :created, location: @my_studio_portrait }
      else
        format.html { render action: "new" }
        format.json { render json: @my_studio_portrait.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /my_studio/portraits/1
  # PUT /my_studio/portraits/1.json
  def update
    @my_studio_portrait = MyStudio::Portrait.find(params[:id])
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

  # DELETE /my_studio/portraits/1
  # DELETE /my_studio/portraits/1.json
  def destroy
    @my_studio_portrait = MyStudio::Portrait.find(params[:id])
    @my_studio_portrait.destroy

    respond_to do |format|
      format.html { redirect_to my_studio_session_portraits_url }
      format.json { head :ok }
    end
  end

  private #=====================================================================================

  def load_my_studio_session
    @my_studio_session = MyStudio::Session.find(params[:session_id]) if params[:session_id]
  end

end