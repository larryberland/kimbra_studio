class MyStudio::DashboardsController < MyStudio::BaseController


  # GET /my_studio/dashboard
  # GET /my_studio/dashboard.json
  def show
    # TODO; need to handle admin user logged in which
    #       does not contain a studio or studio sessions
    @sessions          = @my_studio.sessions.within_seven_days
    @sum_purchases     = @my_studio.carts.collect { |c| c.purchase.try(:total_cents).to_i / 100.0 }.sum
    @commission_rate   = @my_studio.info.commission_rate.to_i
    @total_commissions = @my_studio.carts.collect { |c| c.taxable_sub_total }.sum * @commission_rate / 100.0
    #@my_studio_dashboards = MyStudio::Dashboard.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_studio_dashboards }
    end
  end

end