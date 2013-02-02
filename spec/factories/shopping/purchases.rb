FactoryGirl.define do

  #create_table "shopping_purchases", :force => true do |t|
  #  t.integer  "cart_id"
  #  t.decimal  "tax"
  #  t.decimal  "total"
  #  t.string   "stripe_card_token"
  #  t.string   "stripe_response_id"
  #  t.string   "stripe_paid"
  #  t.string   "stripe_fee"
  #  t.integer  "total_cents"
  #  t.datetime "purchased_at"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #  t.text     "tax_description"
  #end

  factory :shopping_purchase, class: 'Shopping::Purchase', aliases: [:purchase] do
  end
end
