class Admin::OverviewsController < ApplicationController

  # GET /admin/overview
  # GET /admin/overview.json
  def show
    @sessions = MyStudio::Session.all # within_seven_days
    @studio_users = User.with_studio_role
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_overview }
    end
  end

end