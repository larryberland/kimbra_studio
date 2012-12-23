module Minisite
  class FriendsController < BaseController

    respond_to :js

    # GET /minisite/friends/new
    # GET /minisite/friends/new.json
    def new
      @storyline.describe "New friend collection #{@admin_customer_email.my_studio_session.client.email}"
      @admin_customer_friend = Admin::Customer::Friend.new(email: @admin_customer_email,
                                                           name: @admin_customer_email.my_studio_session.client.name)
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @admin_customer_friend }
        format.js
      end
    end

    # GET /minisite/friends/1t7t7rye/edit
    def edit
      @storyline.describe "Editing friend #{@admin_customer_offer.name}"
    end

    # POST /minisite/friends
    # POST /minisite/friends.json
    def create
      # LDB: Changing this pretty sure this was just copied
      #      from admin_customer_offers
      # sure seems like i need a generate here with the portrait etc...
      @admin_customer_friend       = Admin::Customer::Friend.new(params[:admin_customer_friend])
      @admin_customer_friend.email = @admin_customer_email

      result = @admin_customer_friend.save

      respond_to do |format|
        if result

          # assign any unclaimed offers to this friend
          @admin_customer_friend.on_create if result

          # save the friend collection name in our session
          session[:admin_customer_friend_id] = @admin_customer_friend.id

          url =   index_custom_minisite_email_offers_url(@admin_customer_email.tracking)

          format.html { redirect_to url, notice: "My Collection has been named successfully" }
          format.json { render json: minisite_email_friend_url(@admin_customer_email, @admin_customer_friend), status: :created, location: @admin_customer_friend }
          format.js
        else
          format.html { render action: "new" }
          format.json { render json: @admin_customer_friend.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end

    # PUT /minisite/friends/1t7t7rye
    # PUT /minisite/friends/1t7t7rye.json
    def update
      @admin_customer_friend       = Admin::Customer::Friend.find_by_id(params[:id])
      success = @admin_customer_friend.on_update(params[:admin_customer_friend])
      respond_to do |format|
        if success
          format.json { head :ok }
          format.js
        else
          format.json { render json: @admin_customer_friend.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end
  end
end
