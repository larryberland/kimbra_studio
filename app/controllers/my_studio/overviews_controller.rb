class MyStudio::OverviewsController < ApplicationController

  # GET /my_studio/overview
  # GET /my_studio/overview.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_overview }
    end
  end
end
