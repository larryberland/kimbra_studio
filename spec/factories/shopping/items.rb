FactoryGirl.define do

  #create_table "shopping_items", :force => true do |t|
  #  t.integer  "cart_id"
  #  t.integer  "offer_id"
  #  t.integer  "quantity"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #  t.string   "option"
  #  t.string   "option_selected"
  #end

  factory :shopping_item, class: 'Shopping::Item' do
    # cart is coming in
    offer {create(:offer)}
    quantity 1
  #  t.string   "option"
  #  t.string   "option_selected"
  end
end
