class MyStudio::SessionsController < MyStudio::BaseController

  before_filter :form_info

  # GET /my_studio/sessions
  # GET /my_studio/sessions.json
  def index
    search                              = params[:search] || session[:search_my_studio_sessions]
    session[:search_my_studio_sessions] = search
    my_studio                           = current_user.admin? ? nil : @my_studio

    set           = MyStudio::Session.search(my_studio, search)
    @record_count = set.count
    @sessions     = set.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sessions }
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
        format.html { redirect_to my_studio_session_portraits_path(@my_studio_session) }
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

  def is_finished_uploading_portraits
    if sess = MyStudio::Session.find(params[:session_id]) rescue nil
      sess.update_attribute(:finished_uploading_at, Time.now)
      flash[:notice] = t(:my_studio_sessions_finished_uploading_notice_html)
      Notifier.delay.session_ready(params[:session_id])
    end
    redirect_to my_studio_dashboard_path(my_studio_id: sess.studio.id)
  end

  private #==================================================================================

  def form_info
    @categories = Category.order(:name).all.map { |c| [c.name, c.id] }
  end

end