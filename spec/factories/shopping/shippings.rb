FactoryGirl.define do

  #create_table "shopping_shippings", :force => true do |t|
  #  t.integer  "cart_id"
  #  t.string   "shipping_option"
  #  t.integer  "amount"
  #  t.string   "tracking"
  #  t.datetime "created_at",      :null => false
  #  t.datetime "updated_at",      :null => false
  #end

  factory :shopping_shipping, class: 'Shopping::Shipping', aliases: [:shipping] do

    ignore do
      name ShippingOption::OPTIONS.first[0]
      cost_cents ShippingOption::OPTIONS.first[1]
    end

    before (:create) do |shipping, evaluator|
      shipping.shipping_option_name  = evaluator.name
      shipping.amount = evaluator.cost_cents
    end
  end
end
