class Studio::RegistrationsController < ApplicationController

  before_filter :form_info, :only => [:new, :create]

  def new
    @registration = true
    @studio       = Studio.new(:info_studio => InfoStudio.new)
    #render :template => 'user_sessions/new'
  end

  def create
    @info_studio = InfoStudio.new(params[:studio].delete(:info_studio))
    @studio = Studio.new(params[:studio])
    @studio.info_studio = @info_studio if @info_studio
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
