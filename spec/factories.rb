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
  # owner of a studio
  factory :owner, class: 'User' do
    email 'Owner@Studio.com'
    first_name 'Studio'
    last_name 'Owner'
    address_1 '322 Studio Ave'
    address_2 'Suite 345'
    city 'Plentywood'
    password 'password'
    password_confirmation 'password'
    association :state, factory: :state, strategy: :build
    zip_code '59254'

  end
  #create_table "categories", :force => true do |t|
  #  t.string   "name"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end
  factory :category do
    name 'Photo Charms'
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
  factory :studio do
    name 'rspec studio name'
    address_1 '322 Highland Ave'
    address_2 'Suite 123'
    city 'Plentywood'
    association :state, factory: :state, strategy: :create
    zip_code '59254'
    association :country, factory: :country, strategy: :build
    phone_number '406.765.1845'

    owner {create(:owner)}
    info {create(:info)}
    minisite {create(:minisite)}

    # the following most likely will be added
    #   during testing
    #staffers
    #studio_emails
    #clients
    #emails
    #carts

    ignore do
      sessions_count 1
    end

    trait :with_session do
      after :create do |studio, evaluator|
        FactoryGirl.create_list :my_studio_session, evaluator.sessions_count, studio: studio
      end
    end

  end

end