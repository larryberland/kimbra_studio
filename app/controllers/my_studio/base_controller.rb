class MyStudio::BaseController < ApplicationController

  before_filter :load_my_studio

  private #=================================================================

  def load_my_studio
    @my_studio = current_user.studio if current_user
  end

end