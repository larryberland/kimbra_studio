class AboutsController < ApplicationController

  skip_filter :authenticate_user!

  def show
    # TODO this is ugly
    @my_studio = User.find(session['warden.user.user.key'][1]).first.studio if session['warden.user.user.key']

  end

  def signup
    @prospect = Prospect.new
  end

  def contact
    # TODO this is ugly
    @my_studio = User.find(session['warden.user.user.key'][1]).first.studio if session['warden.user.user.key']
    render layout: 'application'
  end

end