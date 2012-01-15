class MyStudio::BaseController < ApplicationController

  before_filter :load_my_studio

  private

  # the current studio is defined by the
  #  currently logged in user.
  def load_my_studio
    @my_studio = current_user.studio if current_user
  end
end
