class Admin::OverviewsController < ApplicationController

  # GET /admin/overview
  # GET /admin/overview.json
  def show
    @sessions = MyStudio::Session.within_seven_days
    @emails = Admin::Customer::Email.unsent
    @studio_users = User.with_studio_role
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_overview }
    end
  end

end