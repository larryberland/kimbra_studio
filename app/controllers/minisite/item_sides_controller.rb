class Minisite::ItemSidesController < InheritedResources::Base

  skip_before_filter :authenticate_user!
  before_filter :set_by_tracking
  before_filter :set_cart_and_client_and_studio
  before_filter :setup_story

  layout 'minisite'

  def update
    @navbar_active = :collection
    portrait_attrs                               = params[:admin_customer_item_side].delete(:portrait_attributes)
    @portrait                                    = MyStudio::Portrait.find(portrait_attrs[:id])
    params[:admin_customer_item_side][:portrait] = @portrait
    success                                      = @item_side.update_attributes(params[:admin_customer_item_side])
    if success
      @storyline.describe 'Saved item side.'
      @offer.update_front_side(@item_side.item)
      success = @offer.save
    end
    respond_to do |format|
      if success
        format.html { redirect_to url_for_workflow(@item_side.item.offer),
                                  notice: t(:minisite_item_sides_update_notice_success, name: @offer.piece.to_offer_name) }
        format.json { head :ok }
      else
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
    @navbar_active = :collection
    @storyline.describe 'Editing item side.'
  end

  private #==========================================================================

  def set_by_tracking
    @item_side = Admin::Customer::ItemSide.find(params[:id]) if params[:id]
    @offer = Admin::Customer::Offer.find_by_tracking(params[:offer_id]) if params[:offer_id]
    @offer ||= @item_side.item.offer
    @email ||= @offer.email if @offer
  end

  def set_cart_and_client_and_studio
    if session[:cart_id]
      @cart = Shopping::Cart.find(session[:cart_id]) rescue nil
    end
    if @cart.nil?
      @cart             = Shopping::Cart.create(:email => @email)
      session[:cart_id] = @cart.id
    end
    session[:admin_customer_email_id] = @email.id
    @client                           = @email.my_studio_session.client
    session[:client_id]               ||= @client.id
    @studio                           = @email.my_studio_session.studio
    session[:studio_id]               ||= @studio.id
    @admin_customer_email             = @email
    @admin_customer_offer             = @offer
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
          minisite_email_offers_path(offer.email.tracking)
      else
        minisite_offer_url(offer) # go to offer edit
      end
    end
  end


end