FactoryGirl.define do

  #create_table "shopping_shippings", :force => true do |t|
  #  t.integer  "cart_id"
  #  t.string   "shipping_option"
  #  t.integer  "total_cents"
  #  t.string   "tracking"
  #  t.datetime "created_at",      :null => false
  #  t.datetime "updated_at",      :null => false
  #end

  factory :shopping_shipping, class: 'Shopping::Shipping', aliases: [:shipping] do
  end
end
