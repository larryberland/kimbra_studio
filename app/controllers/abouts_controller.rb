class AboutsController < ApplicationController

  skip_filter :authenticate_user!

  def show

  end

  def signup
    @prospect = Prospect.new
  end

end