class MyStudio::SessionsController < MyStudio::BaseController

  before_filter :form_info

  # GET /my_studio/sessions
  # GET /my_studio/sessions.json
  def index
    @my_studio_sessions = MyStudio::Session.where('studio_id=?', @my_studio).order('created_at desc')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @my_studio_sessions }
    end
  end

  # GET /my_studio/sessions/1
  # GET /my_studio/sessions/1.json
  def show
    @my_studio_session = MyStudio::Session.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_session }
    end
  end

  # GET /my_studio/sessions/new
  # GET /my_studio/sessions/new.json
  def new
    @my_studio_session = MyStudio::Session.new(:studio => @my_studio, :client => MyStudio::Client.new)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @my_studio_session }
    end
  end

  # GET /my_studio/sessions/1/edit
  def edit
    @my_studio_session = MyStudio::Session.find(params[:id])
  end

  # POST /my_studio/sessions
  # POST /my_studio/sessions.json
  def create
    @client                   = MyStudio::Client.new(params[:my_studio_session].delete(:client))
    @my_studio_session        = MyStudio::Session.new(params[:my_studio_session])
    @my_studio_session.client = @client
    @my_studio_session.studio = @my_studio

    respond_to do |format|
      if @my_studio_session.save
        format.html { redirect_to my_studio_sessions_url, notice: 'Session was successfully created.' }
        format.json { render json: @my_studio_session, status: :created, location: @my_studio_session }
      else
        format.html { render action: "new" }
        format.json { render json: @my_studio_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /my_studio/sessions/1
  # PUT /my_studio/sessions/1.json
  def update
    @my_studio_session = MyStudio::Session.find(params[:id])
    @my_studio_session.client.update_attributes(params[:my_studio_session].delete(:client))

    respond_to do |format|
      if @my_studio_session.update_attributes(params[:my_studio_session])
        format.html { redirect_to my_studio_sessions_url, notice: 'Session was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @my_studio_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_studio/sessions/1
  # DELETE /my_studio/sessions/1.json
  def destroy
    @my_studio_session = MyStudio::Session.find(params[:id])
    @my_studio_session.destroy

    respond_to do |format|
      format.html { redirect_to my_studio_sessions_url }
      format.json { head :ok }
    end
  end

  private #==================================================================================

  def form_info
    @categories = Category.order(:name).all.map { |c| [c.name, c.id] }
  end

end