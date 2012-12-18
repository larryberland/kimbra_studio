class MyStudio::DashboardsController < MyStudio::BaseController

  helper MyStudio::SessionsHelper

  # GET /my_studio/dashboard
  # GET /my_studio/dashboard.json
  def show
    # redirect in sessions controller is passing in the my_studio_id for admin
    @my_studio ||= Studio.find(params[:my_studio_id]) if params[:my_studio_id]
    @sessions          = @my_studio.sessions
    @sum_purchases     = @my_studio.sum_purchases
    @commission_rate   = @my_studio.info.commission_rate.to_i
    @total_commissions = @my_studio.total_commission
    #@my_studio_dashboards = MyStudio::Dashboard.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_dashboards }
    end
  end

  private

  def navbar_active
    @navbar_active = :dashboard
  end

end