FactoryGirl.define do

  #create_table "shopping_stripe_cards", :force => true do |t|
  #  t.integer  "purchase_id"
  #  t.string   "country"
  #  t.string   "cvc_check"
  #  t.integer  "exp_month"
  #  t.integer  "exp_year"
  #  t.string   "last4"
  #  t.string   "stripe_type"
  #  t.string   "stripe_object"
  #  t.datetime "created_at",    :null => false
  #  t.datetime "updated_at",    :null => false
  #end

  factory :shopping_stripe_card, class: 'Shopping::StripeCard', aliases: [:stripe_card] do
  end
end
