class MyStudio::RegistrationsController < MyStudio::BaseController

  before_filter :form_info, :only => [:new, :create]

  def new
    @registration = true
    @studio       = Studio.new(:info => MyStudio::Info.new, :minisite => MyStudio::Minisite.new)
  end

  def create
    @info      = MyStudio::Info.new(params[:studio].delete(:info))
    @minisite = MyStudio::Minisite.new(params[:studio].delete(:minisite))
    @studio    = Studio.new(params[:studio])
    @studio.info = @info if @info
    @studio.minisite = @minisite if @minisite
    @studio.owner = User.new(:email => @info.email)

    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @studio.save
      @studio.deliver_activation_instructions!
      #UserSession.new(@user.attributes)
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to root_url
    else
      @registration = true
      render :template => 'new'
    end
  end

  private #========================================================

  def form_info
    @countries = Country.form_selector
    @states = State.by_country(params[:country_id]).all if params[:country_id].present?
    @states ||= []
  end

end