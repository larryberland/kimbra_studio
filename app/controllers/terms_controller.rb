class TermsController < ApplicationController

  skip_filter :authenticate_user!

  def index
    @my_studio = User.find(session['warden.user.user.key'][1]).first.studio if session['warden.user.user.key']
  end

end