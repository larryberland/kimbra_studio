class Admin::OverviewsController < ApplicationController

  before_filter :reset_session_info

  # GET /admin/overview
  # GET /admin/overview.json
  def show
    @sessions = MyStudio::Session.all
    @emails = Admin::Customer::Email.unsent
    @studio_users = User.with_studio_role
    @unsubscribes = Unsubscribe.all
    @prospects = Prospect.all
    @sessions_ready_count = MyStudio::Session.ready_to_generate_email.count
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_overview }
    end
  end

end