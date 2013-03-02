FactoryGirl.define do

  #create_table "shopping_shippings", :force => true do |t|
  #  t.integer  "cart_id"
  #  t.string   "shipping_option_name"
  #  t.integer  "amount"
  #  t.string   "tracking"
  #  t.datetime "created_at",      :null => false
  #  t.datetime "updated_at",      :null => false
  #end

  # Create a shopping_shipping with Shipping::Options[2] attributes
  #   create(:shipping, index: 2) or
  #   FactoryGirl.create(:shipping, index: 2)
  #
  factory :shopping_shipping, class: 'Shopping::Shipping', aliases: [:shipping] do

    ignore do
      index 0
      shipping_option {FactoryGirl.create(:shipping_option, index: index)}
      cart {FactoryGirl.create(:cart)}
    end

    cart_id {cart.id}
    shipping_option_name {shipping_option.name}
    # amount and tracking are calculated values

  end
end
