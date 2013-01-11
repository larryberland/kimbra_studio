class MyStudio::InfosController < MyStudio::BaseController

  before_filter :load_my_studio_mock, only: [:mock_collection, :mock_collection_return]
  after_filter :setup_session_studio_infos

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
  end

  def samples
    # Static images of various pages.
    # TODO must make these dynamic so they look custom to the studio.
  end

  def faq
    @navbar_active = :infos_faqs
    # Static text.
  end

  # Non-functioning mock of the My Collection page.
  def mock_collection
    @mock_collection = true
    raise "missing session info for studio" if @studio.nil? # handle admin
    render layout: false
  end

  def mock_collection_return
    @mock_collection = :return
    @link_back = true
    raise "missing session info for studio" if @studio.nil? # handle admin
    render action: 'mock_collection', layout: false
  end

  private

  def navbar_active
    @navbar_active = :infos_samples
  end

  def setup_session_studio_infos
    session[:my_studio_infos] ||= {}
    if @my_studio_info and @my_studio_info.studio
      session[:my_studio_infos][:studio_id] = @my_studio_info.studio.id
    end
  end

  # override the load_my_studio filter
  def load_my_studio_mock
    raise "someone forget to set my session info? #{session.inspect}" if session[:my_studio_infos][:studio_id].nil?
    @my_studio = Studio.find_by_id(session[:my_studio_infos][:studio_id])
    @studio = @my_studio
  end

end