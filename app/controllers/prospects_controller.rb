class ProspectsController < ApplicationController

  skip_before_filter :authenticate_user!, only: :create

  def create
    prospect = Prospect.new(email: params[:prospect][:email])
    if prospect.save
      message = 'Thanks! Your email address has been added and we\'ll let you know when we launch.'
    else
      message = "Whoops! #{prospect.errors.full_messages.join(', ')}"
    end
    redirect_to root_path, notice: message
  end

end