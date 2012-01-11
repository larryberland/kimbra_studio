class Studio::ActivationsController < ApplicationController

  # This method should be an "update method" but
  # I imagine some email clients will have a hard time with this.
  # plus some people will want to copy and paste the link.
  def show
    @studio = Studio.find_by_perishable_token(params[:a])
    if @studio && (@studio.active? || @studio.activate!)
      # TODO: determine our UserSession.create(@user, true)
      flash[:notice] = "Welcome back #{@studio.name}"
    else
      flash[:notice] = "Invalid Activation URL!"
    end
    redirect_to root_url
  end

  private

  def form_info

  end
end
