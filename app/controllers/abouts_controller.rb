class AboutsController < ApplicationController

  skip_filter :authenticate_user!

  def show
    # no-op for this view
  end

  def signup
    @prospect = Prospect.new
  end

  def contact
    # no-op for this view
  end

end