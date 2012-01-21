class Admin::Customer::ItemsController < InheritedResources::Base
  belongs_to :offer,
             :parent_class => Admin::Customer::Offer


  def update
    puts "params=>#{params.inspect}"
    @item  = Admin::Customer::Item.find(params[:id])
    offset = [@item.item_x, @item.item_y]
    size   = [@item.item_width, @item.item_height]

    update! do |success, failure|
      if (size.first != @item.item_width) or (size.last != @item.item_height)
        @item.resize_image
        @item.reposition_image
      elsif (offset.first != @item.item_x) or (offset.last != @item.item_y)
        @item.reposition_image
      end

      success.html { render action: "edit" }
      failure.html { render action: "edit" }
    end
  end

end
