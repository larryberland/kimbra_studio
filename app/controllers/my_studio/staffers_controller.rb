class MyStudio::StaffersController < MyStudio::BaseController

  before_filter :form_info

  # GET /my_studio/staffers
  # GET /my_studio/staffers.json
  def index
    @my_studio_staffers = @my_studio.staffers.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @my_studio_staffers }
    end
  end

  # GET /my_studio/staffers/1
  # GET /my_studio/staffers/1.json
  def show
    @my_studio_staffer = MyStudio::Staffer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_staffer }
    end
  end

  # GET /my_studio/staffers/new
  # GET /my_studio/staffers/new.json
  def new
    @my_studio_staffer = User.new(:roles => [Role.find_by_name(Role::STUDIO_STAFF)])
    @my_studio_staffer.studio = @studio

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @my_studio_staffer }
    end
  end

  # GET /my_studio/staffers/1/edit
  def edit
    @my_studio_staffer = MyStudio::Staffer.find(params[:id])
  end

  # POST /my_studio/staffers
  # POST /my_studio/staffers.json
  def create
    attrs = params[:user]  # using users/_form.html.erb
    attrs[:studio] = @studio
    @my_studio_staffer = User.new(attrs)
    @my_studio_staffer.roles = [Role.find_by_name(Role::STUDIO_STAFF)]

    respond_to do |format|
      if @my_studio_staffer.save
        format.html { redirect_to @my_studio_staffer, notice: 'Staffer was successfully created.' }
        format.json { render json: @my_studio_staffer, status: :created, location: @my_studio_staffer }
      else
        format.html { render action: "new" }
        format.json { render json: @my_studio_staffer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /my_studio/staffers/1
  # PUT /my_studio/staffers/1.json
  def update
    @my_studio_staffer = MyStudio::Staffer.find(params[:id])

    respond_to do |format|
      if @my_studio_staffer.update_attributes(params[:my_studio_staffer])
        format.html { redirect_to @my_studio_staffer, notice: 'Staffer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @my_studio_staffer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_studio/staffers/1
  # DELETE /my_studio/staffers/1.json
  def destroy
    @my_studio_staffer = MyStudio::Staffer.find(params[:id])
    @my_studio_staffer.destroy

    respond_to do |format|
      format.html { redirect_to my_studio_staffers_url }
      format.json { head :ok }
    end
  end
  private

  def form_info
    @states = State.form_selector
  end

end
