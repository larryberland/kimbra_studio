module Minisite
  class FriendsController < BaseController

    respond_to :js

    # GET /minisite/friends/1t7t7rye/edit
    def edit
      @storyline.describe "Editing friend #{@admin_customer_offer.name}"
    end

    # PUT /minisite/friends/1t7t7rye
    # PUT /minisite/friends/1t7t7rye.json
    def update
      @admin_customer_friend       = Admin::Customer::Friend.find_by_id(params[:id])
      success = @admin_customer_friend.on_update(params[:admin_customer_friend])
      respond_to do |format|
        if success
          @storyline.describe "Updating friend #{@admin_customer_offer.name}"
          format.json { head :ok }
          format.js
        else
          @storyline.describe "Updating friend #{@admin_customer_offer.name} errors: #{@admin_customer_friend.errors.full_messages}"
          format.json { render json: @admin_customer_friend.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

  end
end