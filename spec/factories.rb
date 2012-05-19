# auto loaded by FactoryGirl
require 'faker'

FactoryGirl.define do

  factory :admin, class: User do
      first_name "Admin"
      last_name  "User"
      association :roles, factory: :role, strategy: :build
  end

  factory :user_staff do

  end

  #create_table "users", :force => true do |t|
  #  t.integer  "studio_id"
  #  t.string   "first_name"
  #  t.string   "last_name"
  #  t.date     "birth_date"
  #  t.string   "friendly_name"
  #  t.string   "email",                                 :default => "", :null => false
  #  t.string   "phone_number"
  #  t.string   "address_1"
  #  t.string   "address_2"
  #  t.string   "state"
  #  t.string   "city"
  #  t.integer  "state_id"
  #  t.string   "zip_code"
  #  t.integer  "country_id"
  #  t.string   "customer_cim_id"
  #  t.string   "password_salt"
  #  t.string   "crypted_password"
  #  t.string   "perishable_token"
  #  t.string   "persistence_token"
  #  t.string   "access_token"
  #  t.integer  "comments_count",                        :default => 0
  #  t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
  #  t.string   "confirmation_token"
  #  t.datetime "confirmed_at"
  #  t.datetime "confirmation_sent_at"
  #  t.string   "reset_password_token"
  #  t.datetime "reset_password_sent_at"
  #  t.datetime "remember_created_at"
  #  t.integer  "sign_in_count",                         :default => 0
  #  t.datetime "current_sign_in_at"
  #  t.datetime "last_sign_in_at"
  #  t.string   "current_sign_in_ip"
  #  t.string   "last_sign_in_ip"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end

  factory :user do
    first_name 'rspec'
    last_name 'test'
    address_1 '322 Highland Ave'
    address_2 'Suite 321'
    city 'Plentywood'
    email 'rspec_user@rspec.com'
    password 'password'
    password_confirmation 'password'
    association :state, factory: :state, strategy: :build
    zip_code '59254'

    factory :user_with_role do
      after_create do |user, evaluator|
        role =   Role.find_or_create_by_name(evaluator)
        Factory.create_list(:roles, 1, user: user, role: role)
      end
    end

  end

  #create_table "countries", :force => true do |t|
  #  t.string "name"
  #  t.string "abbreviation", :limit => 5
  #end
  factory :country do
    name 'United States'
    abbreviation 'USA'
  end
  #create_table "states", :force => true do |t|
  #  t.string  "name",                          :null => false
  #  t.string  "abbreviation",     :limit => 5, :null => false
  #  t.string  "described_as"
  #  t.integer "country_id",                    :null => false
  #  t.integer "shipping_zone_id",              :null => false
  #end
  factory :state do
    name 'Montana'
    abbreviation 'MT'
    described_as 'State'
    association :country
    shipping_zone_id 1  # currently not supported so set all to 1
  end

  #create_table "studios", :force => true do |t|
  #  t.string   "name"
  #  t.string   "address_1"
  #  t.string   "address_2"
  #  t.string   "city"
  #  t.integer  "state_id"
  #  t.string   "zip_code"
  #  t.integer  "country_id"
  #  t.string   "phone_number"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end
  factory :studio do |r|
    name 'rspec studio name'
    address_1 '322 Highland Ave'
    address_2 'Suite 123'
    city 'Plentywood'
    association :state, factory: :state, strategy: :build
    zip_code '59254'
    association :country, factory: :country, strategy: :build
    phone_number '406.765.1845'
  end

  ##create_table "admin_customer_emails", :force => true do |t|
  ##  t.integer  "my_studio_session_id"
  ##  t.boolean  "active",               :default => true
  ##  t.text     "message"
  ##  t.string   "tracking"
  ##  t.string   "activation_code"
  ##  t.datetime "generated_at"
  ##  t.datetime "sent_at"
  ##  t.datetime "opened_at"
  ##  t.datetime "visited_at"
  ##  t.datetime "created_at"
  ##  t.datetime "updated_at"
  ##end
  #factory :email, class: AdminCustomer::Email do
  #  association my_studio_session
  #  active true
  #  message 'email message text'
  #  tracking UUID.random_tracking_number
  #  activation_code nil
  #  generated_at nil
  #  sent_at nil
  #  opened_at nil
  #  visited_at nil
  #end
  #
  ##create_table "admin_customer_items", :force => true do |t|
  ##  t.integer  "offer_id"
  ##  t.integer  "part_id"
  ##  t.boolean  "photo",      :default => true
  ##  t.integer  "width"
  ##  t.integer  "height"
  ##  t.datetime "created_at"
  ##  t.datetime "updated_at"
  ##end
  #factory :item, class: AdminCustomer::Item do
  #  association :offer
  #  association :part
  #  photo true
  #  width 400
  #  height 400
  #end
  #
  ##create_table "admin_customer_item_sides", :force => true do |t|
  ##  t.integer  "item_id"
  ##  t.integer  "part_id"
  ##  t.integer  "portrait_id"
  ##  t.integer  "face_id"
  ##  t.datetime "changed_layout_at"
  ##  t.string   "image_stock"
  ##  t.string   "image_custom"
  ##  t.datetime "created_at"
  ##  t.datetime "updated_at"
  ##end
  #factory :item_side, class: AdminCustomer::ItemSide do |r|
  #  r.association :item
  #  r.association :part
  #  r.association :portrait
  #  r.association :face
  #  r.changed_layout_at nil
  #  image_stock { fixture_file_upload("files/example.jpg", "image/jpeg") }
  #  image_custom { fixture_file_upload("files/example.jpg", "image/jpeg") }
  #end
  #
  ##create_table "admin_customer_offers", :force => true do |t|
  ##  t.integer "email_id"
  ##  t.integer "piece_id"
  ##  t.string "tracking"
  ##  t.string "image"
  ##  t.string "image_front"
  ##  t.string "image_back"
  ##  t.boolean "active", :default => true
  ##  t.string "name"
  ##  t.text "description"
  ##  t.string "custom_layout", :default => "order"
  ##  t.string "activation_code"
  ##  t.datetime "visited_at"
  ##  t.datetime "purchased_at"
  ##  t.integer "width"
  ##  t.integer "height"
  ##  t.datetime "created_at"
  ##  t.datetime "updated_at"
  ##end
  #factory :offer, class: AdminCustomer::Offer do
  #  association email
  #  association piece
  #  tracking UUID.random_string
  #  image
  #  image_front
  #  image_back
  #  name 'rspec_offer_name'
  #  description 'rspec_offer_description text'
  #  custom_layout 'order'
  #  activation_code
  #  visited_at nil
  #  purchased_at nil
  #  width 400
  #  height 400
  #end
  #
  ##create_table "my_studio_sessions", :force => true do |t|
  ##  t.integer  "studio_id"
  ##  t.integer  "client_id"
  ##  t.integer  "category_id"
  ##  t.string   "name"
  ##  t.datetime "session_at"
  ##  t.boolean  "active",      :default => true
  ##  t.datetime "created_at"
  ##  t.datetime "updated_at"
  ##end
  #factory :session, class: MyStudio::Session do
  #  association :studio
  #  association :client
  #  association :category
  #  name 'rspec studio session'
  #  active true
  #  session_at Time.now
  #end

end