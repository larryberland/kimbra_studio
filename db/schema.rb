# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120111175610) do

  create_table "address_types", :force => true do |t|
    t.string "name",        :limit => 64, :null => false
    t.string "description"
  end

  add_index "address_types", ["name"], :name => "index_address_types_on_name"

  create_table "addresses", :force => true do |t|
    t.integer  "address_type_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "addressable_type",                    :null => false
    t.integer  "addressable_id",                      :null => false
    t.string   "address1",                            :null => false
    t.string   "address2"
    t.string   "city",                                :null => false
    t.integer  "state_id"
    t.string   "state_name"
    t.string   "zip_code",                            :null => false
    t.integer  "phone_id"
    t.boolean  "default",          :default => false
    t.boolean  "billing_default",  :default => false
    t.boolean  "active",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_id"], :name => "index_addresses_on_addressable_id"
  add_index "addresses", ["addressable_type"], :name => "index_addresses_on_addressable_type"
  add_index "addresses", ["state_id"], :name => "index_addresses_on_state_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
    t.string "abbreviation", :limit => 5
  end

  add_index "countries", ["name"], :name => "index_countries_on_name"

  create_table "info_studios", :force => true do |t|
    t.boolean  "active"
    t.string   "email_info"
    t.string   "email"
    t.string   "tax_id"
    t.string   "website"
    t.boolean  "pictage_member"
    t.boolean  "mac_user"
    t.boolean  "windows_user"
    t.boolean  "ping_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "studio_id"
  end

  create_table "mini_site_studios", :force => true do |t|
    t.string   "bgcolor"
    t.string   "logo"
    t.string   "font_family"
    t.string   "font_color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "studio_id"
  end

  create_table "offers", :force => true do |t|
    t.string   "image"
    t.integer  "pieces_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "name"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pieces", :force => true do |t|
    t.string   "name"
    t.string   "short_description"
    t.string   "long_description"
    t.string   "sku"
    t.decimal  "price",             :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured"
    t.datetime "deleted_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name", :limit => 30, :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "states", :force => true do |t|
    t.string  "name",                          :null => false
    t.string  "abbreviation",     :limit => 5, :null => false
    t.string  "described_as"
    t.integer "country_id",                    :null => false
    t.integer "shipping_zone_id",              :null => false
  end

  add_index "states", ["abbreviation"], :name => "index_states_on_abbreviation"
  add_index "states", ["country_id"], :name => "index_states_on_country_id"
  add_index "states", ["name"], :name => "index_states_on_name"

  create_table "studio_clients", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.boolean  "active"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "studio_clients", ["address_id"], :name => "index_studio_clients_on_address_id"

  create_table "studio_pictures", :force => true do |t|
    t.string   "description"
    t.string   "file_name"
    t.boolean  "active"
    t.integer  "shoot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  add_index "studio_pictures", ["shoot_id"], :name => "index_studio_pictures_on_shoot_id"

  create_table "studio_shoots", :force => true do |t|
    t.string   "name"
    t.datetime "date"
    t.integer  "studio_id"
    t.integer  "client_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "studio_shoots", ["category_id"], :name => "index_studio_shoots_on_category_id"
  add_index "studio_shoots", ["client_id"], :name => "index_studio_shoots_on_client_id"
  add_index "studio_shoots", ["studio_id"], :name => "index_studio_shoots_on_studio_id"

  create_table "studios", :force => true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
  end

  add_index "user_roles", ["role_id"], :name => "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], :name => "index_user_roles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.string   "email"
    t.string   "state"
    t.integer  "account_id"
    t.string   "customer_cim_id"
    t.string   "password_salt"
    t.string   "crypted_password"
    t.string   "perishable_token"
    t.string   "persistence_token"
    t.string   "access_token"
    t.integer  "comments_count",           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "database_authenticatable"
    t.boolean  "recoverable"
    t.boolean  "rememberable"
    t.boolean  "trackable"
    t.string   "reset_password_token"
    t.string   "encrypted_password"
    t.integer  "studio_id"
  end

  add_index "users", ["access_token"], :name => "index_users_on_access_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
