class Minisite::ItemSidesController < InheritedResources::Base

  skip_before_filter :authenticate_user!
  before_filter :setup_story

  layout 'minisite'

  def update
    @navbar_active = :collection
    submit_save    = t('minisite.item_sides.form.save.name')
    success        = if (params[:commit] == submit_save)
                       # only update this single side
                       if (is_client?)
                         notice = t('minisite.item_sides.update.notice.success', name: @offer.piece.to_offer_name)
                       else
                         notice = t('minisite.item_sides.update.notice.success_suggestion', name: @offer.piece.to_offer_name)
                       end
                       update_item_side
                     else
                       # we are creating a new offer for this item_side and all its item_sides
                       notice = t('minisite.item_sides.update.notice.success_add', name: @offer.piece.to_offer_name)
                       create_offer_for_my_collection
                     end
    respond_to do |format|
      if success
        @storyline.describe "Updated piece. Redirecting to #{@item_side.item.offer.name}"
        format.html { redirect_to url_for_workflow(@item_side.item.offer), notice: notice }
        format.json { head :ok }
      else
        @storyline.describe "Updating piece failed #{@item_side.errors.full_messages}."
        format.html { render action: 'edit' }
        format.json { render json: @item_side.errors, status: :unprocessable_entity }
      end
    end
  end

          # get /minisite/offers/tracking/portrait
  def portrait
    @storyline.describe 'Selecting a new portrait.'
    @portrait = MyStudio::Portrait.find(params[:portrait_id]) rescue nil
  end

  def stock
    @storyline.describe 'Selecting stock portrait.'
    @portrait = MyStudio::Portrait.find(params[:item_side_id]) rescue nil
    render :portrait
  end

  def edit
    @navbar_active = is_client? ? :collection : :suggestions
    @storyline.describe 'Editing item side.'
  end

  private #==========================================================================

  def update_item_side
    portrait_attrs                               = params[:admin_customer_item_side].delete(:portrait_attributes)
    @portrait                                    = MyStudio::Portrait.find(portrait_attrs[:id])
    params[:admin_customer_item_side][:portrait] = @portrait
    success                                      = @item_side.update_attributes(params[:admin_customer_item_side])
    if success
      @storyline.describe 'Saved item side.'
      @offer.update_front_side(@item_side.item)
      success = @offer.save
    end
    success
  end

  def create_offer_for_my_collection
    @storyline.describe 'Add Adjust Photo offer to My Collection.'
    @offer, @item_side = @offer.generate_from_item_side(@item_side)
    # assign the new offer with client's friend info
    @offer.friend = @admin_customer_friend if @admin_customer_friend
    update_item_side
  end

  # handle some workflow for admin when adjusting pictures
  #  in the offers.
  # when offer only has a single front item
  #   go directly to adjust picture and return to collection
  #   otherwise go to multi item edit window and back
  def url_for_workflow(offer)
    if (offer.items.size > 1)
      minisite_offer_items_url(offer) # keep editing the other item_sides
    else
      if (is_admin? and (!offer.has_back?))
        # go directly to collection
        minisite_email_offers_url(offer.email.tracking)
      else
        minisite_email_offer_url(offer.email.tracking, offer) # go to offer edit
      end
    end
  end

  # override ApplicationController so we can
  #   set our email and offer based on this controllers info
  def minisite_info_inherited_resources

    @item_side = Admin::Customer::ItemSide.find(params[:id]) if params[:id]
    @offer = Admin::Customer::Offer.find_by_tracking(params[:offer_id]) if params[:offer_id]
    @offer ||= @item_side.item.offer
    @email ||= @offer.email if @offer

    sync_session_email(@email) # sync email and cart info
                               # setup our common controller email
    @admin_customer_email = @email

    # set attributes that are used later in the filters
    @admin_customer_offer = @offer if @offer

  end


end