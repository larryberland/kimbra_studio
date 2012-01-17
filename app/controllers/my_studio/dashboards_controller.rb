class MyStudio::DashboardsController < MyStudio::BaseController
  # GET /my_studio/dashboard
  # GET /my_studio/dashboard.json
  def show
    #@my_studio_dashboards = MyStudio::Dashboard.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_dashboards }
    end
  end

end
