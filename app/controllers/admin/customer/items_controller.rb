class Admin::Customer::ItemsController < InheritedResources::Base

  belongs_to :offer,
             :parent_class => Admin::Customer::Offer

  def update
    @item  = Admin::Customer::Item.find(params[:id])
    offset = [@item.part.part_layout.x, @item.part.part_layout.y]
    size   = [@item.part.part_layout.w, @item.part.part_layout.h]

    update! do |success, failure|

      success.html { render action: "edit" }
      failure.html { render action: "edit" }
    end
  end

end