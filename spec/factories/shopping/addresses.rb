FactoryGirl.define do
  #create_table "shopping_addresses", :force => true do |t|
  #  t.integer  "cart_id"
  #  t.string   "first_name"
  #  t.string   "last_name"
  #  t.string   "address1"
  #  t.string   "address2"
  #  t.string   "city"
  #  t.integer  "state_id"
  #  t.string   "zip_code"
  #  t.string   "country",    :default => "USA"
  #  t.string   "email"
  #  t.datetime "created_at",                    :null => false
  #  t.datetime "updated_at",                    :null => false
  #  t.string   "phone"
  #end

  factory :shopping_address, class: 'Shopping::Address', aliases: [:address] do
  end
end
