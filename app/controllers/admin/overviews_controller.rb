class Admin::OverviewsController < ApplicationController

  # GET /admin/overview
  # GET /admin/overview.json
  def show
    @sessions = MyStudio::Session.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_overview }
    end
  end

end