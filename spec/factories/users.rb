# auto loaded by FactoryGirl
require 'faker'

FactoryGirl.define do

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

end