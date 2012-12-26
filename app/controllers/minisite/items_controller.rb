class Minisite::ItemsController < InheritedResources::Base

  belongs_to :offer,
             :parent_class => Admin::Customer::Offer

  skip_before_filter :authenticate_user!
  # handle all the filters BaseController runs
  before_filter :minisite_info_inherited_resources

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
        @storyline.describe 'Failed saving item.'
        render action: "edit"
      end
    end
  end

  private #=================================================================

  def set_by_tracking
    # override baseController to set inherited resources @offer, @email
    @offer = Admin::Customer::Offer.find_by_tracking(params[:id]) if params[:id]
    @offer = Admin::Customer::Offer.find_by_tracking(params[:offer_id]) if params[:offer_id]
    @email ||= @offer.email if @offer
  end

    # current navbar menu
  # :collection, :charms, :chains, :brand, :shopping_cart
  def navbar_active
    # reset in controller for active navbar menu item
    @navbar_active = is_client? ? :collection : :suggestions
  end

end