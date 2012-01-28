class Admin::Customer::ItemsController < InheritedResources::Base
  belongs_to :offer,
             :parent_class => Admin::Customer::Offer

  def update
    puts "params=>#{params.inspect}"
    @item  = Admin::Customer::Item.find(params[:id])
    offset = [@item.part.part_layout.x, @item.part.part_layout.y]
    size   = [@item.part.part_layout.w, @item.part.part_layout.h]

    update! do |success, failure|
      if (size.first != @item.part.part_layout.w) or (size.last != @item.part.part_layout.h)
        @item.resize_image
        @item.reposition_image
      elsif (offset.first != @item.part.part_layout.x) or (offset.last != @item.part.part_layout.y)
        @item.reposition_image
      end

      success.html { render action: "edit" }
      failure.html { render action: "edit" }
    end
  end

end
