class WelcomeController < ApplicationController

  skip_before_filter :authenticate_user!, only: :index
  before_filter :do_not_cache, only: :index

  def index
    #@featured_piece = Piece.featured
    #@best_selling_pieces = Piece.limit(3)
    #@other_pieces  ## search 2 or 3 categories (maybe based on the user)
    unless @featured_piece
      if user_signed_in?
        if current_user.studio? or current_user.studio_staff?
          if current_user.studio.nil?
            redirect_to new_studio_url
          else
            redirect_to my_studio_dashboard_url
          end
        elsif current_user.admin?
          redirect_to admin_overview_url
        end
      end
      if current_user
        #puts "role=>#{current_user.roles.inspect}"
        #if current_user.admin?
        #  raise 'welcome role admin not implemented'
        #elsif current_user.studio?
        #  if current_user.studio_id
        #    redirect_to studio_upload_url
        #  else
        #    redirect_to new_studio_registration_url
        #  end
        #elsif current_user.studio_staff?
        #  raise "welcome role studio_staff not implemented yet"
        #elsif current_user.client?
        #  raise "welcome role client not implemented yet"
        #else
        #  redirect_to login_url
        #end
      end
    end
  end

end