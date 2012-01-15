class Studio::RegistrationsController < ApplicationController

  before_filter :form_info, :only => [:new, :create]

  def new
    @registration = true
    @studio       = Studio.new(:info => MyStudio::Info.new, :mini_site => MyStudio::MiniSite.new)
    #render :template => 'user_sessions/new'
  end

  def create
    @info = MyStudio::Info.new(params[:studio].delete(:info))
    @mini_site = MyStudio::MiniSite.new(params[:studio].delete(:mini_site))
    @studio = Studio.new(params[:studio])
    @studio.info = @info if @info
    @studio.mini_site = @mini_site if @mini_site
    @studio.current_user = current_user

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

  private

  def form_info
    @countries = Country.form_selector
    @states = State.all_with_country_id(params[:country_id]) if params[:country_id].present?
    @states ||= []
  end

end
