class Minisite::ItemsController < InheritedResources::Base

  belongs_to :offer,
             :parent_class => Admin::Customer::Offer

  skip_before_filter :authenticate_user!
  before_filter :setup_story

  layout 'minisite'

  def index
    @storyline.describe 'Viewing item list.'
    index!
  end

  def update
    @item  = Admin::Customer::Item.find(params[:id])
    offset = [@item.part.part_layout.x, @item.part.part_layout.y]
    size   = [@item.part.part_layout.w, @item.part.part_layout.h]
    update! do |success, failure|
      success.html do
        @storyline.describe 'Saved item.'
        render action: "edit"
      end
      failure.html do
        @storyline.describe "Failed saving item #{@item.errors.full_messages}."
        render action: "edit"
      end
    end
  end

  private #=================================================================

  # current navbar menu
  # :collection, :charms, :chains, :brand, :shopping_cart
  def navbar_active
    # reset in controller for active navbar menu item
    @navbar_active = is_client? ? :collection : :suggestions
  end

  # override ApplicationController so we can
  #   set our email and offer based on this controllers info
  def minisite_info_inherited_resources
    # override baseController to set inherited resources @offer, @email

    if ("#{params[:id].to_i}" == params[:id])
      raise "this is not a tracking number"
    end
    @offer = Admin::Customer::Offer.find_by_tracking(params[:id]) if params[:id]
    @offer = Admin::Customer::Offer.find_by_tracking(params[:offer_id]) if params[:offer_id]
    @email ||= @offer.email if @offer

    if @email

      sync_session_email(@email) # sync email and cart info
                                 # setup our common controller email
      @admin_customer_email = @email

    else
      raise "Is there a reason we dont' have an email?"
    end

    # convert inherited resources to our BaseController attrs
    @admin_customer_offer = @offer if @offer

  end

end