module Minisite
  class FriendsController < BaseController

    respond_to :js

    # GET /minisite/emails/:tracking/friends/1t7t7rye/edit
    def edit
      @storyline.describe "Editing friend #{@admin_customer_friend.name}"
    end

    # PUT /minisite/emails/:tracking/friends/1t7t7rye
    # PUT /minisite/emails/:tracking/friends/1t7t7rye.json
    def update
      @admin_customer_friend       = Admin::Customer::Friend.find_by_id(params[:id])
      success = @admin_customer_friend.on_update(params[:admin_customer_friend])
      respond_to do |format|
        if success
          @storyline.describe "Updating friend #{@admin_customer_friend.name}"
          format.json { head :ok }
          format.js
        else
          @storyline.describe "Updating friend errors: #{@admin_customer_friend.errors.full_messages}"
          format.json { render json: @admin_customer_friend.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    private

    def load_email_or_cart
      raise "Friends controller should always have an email_id" unless params.key?(:email_id)
      @admin_customer_email = Admin::Customer::Email.find_by_tracking(params[:email_id])
      sync_session_email(@admin_customer_email)
    end

  end

end