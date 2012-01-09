class WelcomeController < ApplicationController

  # no special layout right now layout 'welcome'

  def index
    @featured_piece = Piece.featured
    @best_selling_pieces = Piece.limit(3)
    @other_pieces  ## search 2 or 3 categories (maybe based on the user)
    unless @featured_piece
      if current_user
        if current_user.admin?
          redirect_to login_url # TODO: find admin process if any => admin_merchandise_products_url
        elsif current_user.studio?
          redirect_to new_studio_registration_url
        elsif current_user.studio_staff?
          raise "studio_staff not implemented yet"
          redirect_to login_url
        elsif current_user.client?
          redirect_to login_url
        else
          redirect_to login_url
        end
      end
      if current_user && current_user.admin?
      else
      end
    end
  end
end
