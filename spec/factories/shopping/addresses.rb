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
    first_name "First"
    last_name "House"
    address1 "222 Highland Avenue"
    city "Plentywood"
    state { build(:state) }
    zip_code "59254"
    country "USA"  # Not sure why we have this since State has a country
    email "JaneShopping@Email.com"
    phone "406.369.1234"
    cart do
      puts "address cart create"
      create(:cart)
    end
    before :create do |address|
      puts "address :create"
    end
  end
end
