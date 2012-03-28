module Shopping
  class ItemsController < BaseController
    #belongs_to :cart,
    #           :parent_class => Shopping::Cart
    #belongs_to :offer,
    #           :parent_class => Admin::Customer::Offer
    respond_to :js, :only => [:create, :destroy]

    def new
      new!
    end

    def create
      params[:cart_id] = params[:shopping_item][:cart_id]
      params[:offer_id] = params[:shopping_item][:offer_id]
      @showroom = Admin::Customer::Offer.find(params[:offer_id]).email.showroom
      create!
    end

    def destroy
      destroy!
    end

  end
end