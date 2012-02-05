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

ActiveRecord::Schema.define(:version => 20120204193650) do

  create_table "admin_customer_emails", :force => true do |t|
    t.integer  "my_studio_session_id"
    t.boolean  "active",               :default => true
    t.text     "message"
    t.string   "activation_code"
    t.datetime "generated_at"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "visited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_customer_emails", ["my_studio_session_id"], :name => "index_admin_customer_emails_on_my_studio_session_id"

  create_table "admin_customer_item_sides", :force => true do |t|
    t.integer  "item_id"
    t.integer  "part_id"
    t.integer  "portrait_id"
    t.integer  "face_id"
    t.datetime "changed_layout_at"
    t.string   "image_stock"
    t.string   "image_custom"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_customer_items", :force => true do |t|
    t.integer  "offer_id"
    t.integer  "part_id"
    t.boolean  "photo",      :default => true
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_customer_items", ["offer_id"], :name => "index_admin_customer_items_on_offer_id"
  add_index "admin_customer_items", ["part_id"], :name => "index_admin_customer_items_on_part_id"

  create_table "admin_customer_offers", :force => true do |t|
    t.integer  "email_id"
    t.integer  "piece_id"
    t.string   "image"
    t.string   "image_front"
    t.string   "image_back"
    t.boolean  "active",          :default => true
    t.string   "name"
    t.text     "description"
    t.string   "custom_layout",   :default => "order"
    t.string   "activation_code"
    t.datetime "visited_at"
    t.datetime "purchased_at"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_customer_offers", ["email_id"], :name => "index_admin_customer_offers_on_email_id"
  add_index "admin_customer_offers", ["piece_id"], :name => "index_admin_customer_offers_on_piece_id"

  create_table "admin_merchandise_parts", :force => true do |t|
    t.integer  "piece_id"
    t.integer  "portrait_id"
    t.string   "image_part"
    t.string   "image"
    t.integer  "order",       :default => 0
    t.boolean  "photo",       :default => true
    t.integer  "width"
    t.integer  "height"
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_merchandise_parts", ["piece_id"], :name => "index_admin_merchandise_parts_on_piece_id"
  add_index "admin_merchandise_parts", ["portrait_id"], :name => "index_admin_merchandise_parts_on_portrait_id"

  create_table "admin_merchandise_pieces", :force => true do |t|
    t.string   "category"
    t.string   "name"
    t.string   "image"
    t.string   "short_description"
    t.text     "description_markup"
    t.string   "sku"
    t.decimal  "price"
    t.string   "custom_layout",      :default => "order"
    t.integer  "width",              :default => 0
    t.integer  "height",             :default => 0
    t.boolean  "active",             :default => true
    t.boolean  "featured"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_merchandise_pieces", ["name", "category"], :name => "index_admin_merchandise_pieces_on_name_and_category", :unique => true

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

  create_table "image_layouts", :force => true do |t|
    t.string   "layout_type"
    t.integer  "layout_id"
    t.integer  "x"
    t.integer  "y"
    t.integer  "w"
    t.integer  "h"
    t.decimal  "degrees"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "minisite_showrooms", :force => true do |t|
    t.integer  "offer_id"
    t.integer  "customer_id"
    t.integer  "studio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "minisite_showrooms", ["customer_id"], :name => "index_minisite_showrooms_on_customer_id"
  add_index "minisite_showrooms", ["offer_id"], :name => "index_minisite_showrooms_on_offer_id"
  add_index "minisite_showrooms", ["studio_id"], :name => "index_minisite_showrooms_on_studio_id"

  create_table "my_studio_clients", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.boolean  "active",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_studio_infos", :force => true do |t|
    t.integer  "studio_id"
    t.boolean  "active",             :default => true
    t.string   "website"
    t.string   "email"
    t.string   "email_notification"
    t.string   "tax_ein"
    t.boolean  "pictage_member"
    t.boolean  "smug_mug_member"
    t.boolean  "mac_user"
    t.boolean  "windows_user"
    t.boolean  "ping_email",         :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_studio_infos", ["studio_id"], :name => "index_my_studio_infos_on_studio_id"

  create_table "my_studio_mini_sites", :force => true do |t|
    t.integer  "studio_id"
    t.string   "bgcolor"
    t.string   "image"
    t.string   "font_family"
    t.string   "font_color"
    t.string   "theme"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_studio_mini_sites", ["studio_id"], :name => "index_my_studio_mini_sites_on_studio_id"

  create_table "my_studio_portrait_faces", :force => true do |t|
    t.integer  "portrait_id"
    t.decimal  "center_x"
    t.decimal  "center_y"
    t.decimal  "width"
    t.decimal  "height"
    t.decimal  "eye_left_x"
    t.decimal  "eye_left_y"
    t.decimal  "eye_right_x"
    t.decimal  "eye_right_y"
    t.decimal  "mouth_left_x"
    t.decimal  "mouth_left_y"
    t.decimal  "mouth_center_x"
    t.decimal  "mouth_center_y"
    t.decimal  "mouth_right_x"
    t.decimal  "mouth_right_y"
    t.decimal  "nose_x"
    t.decimal  "nose_y"
    t.decimal  "ear_left_x"
    t.decimal  "ear_left_y"
    t.decimal  "ear_right_x"
    t.decimal  "ear_right_y"
    t.decimal  "chin_x"
    t.decimal  "chin_y"
    t.decimal  "yaw"
    t.decimal  "roll"
    t.decimal  "pitch"
    t.text     "tag_attributes"
    t.integer  "face_top_left_x"
    t.integer  "face_top_left_y"
    t.integer  "face_width"
    t.integer  "face_height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_studio_portrait_faces", ["portrait_id"], :name => "index_my_studio_portrait_faces_on_portrait_id"

  create_table "my_studio_portraits", :force => true do |t|
    t.string   "image"
    t.string   "description"
    t.integer  "width",                :default => 0
    t.integer  "height",               :default => 0
    t.boolean  "active",               :default => true
    t.integer  "my_studio_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_studio_portraits", ["my_studio_session_id"], :name => "index_my_studio_portraits_on_my_studio_session_id"

  create_table "my_studio_sessions", :force => true do |t|
    t.string   "name"
    t.datetime "session_at"
    t.boolean  "active",      :default => true
    t.integer  "studio_id"
    t.integer  "client_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_studio_sessions", ["category_id"], :name => "index_my_studio_sessions_on_category_id"
  add_index "my_studio_sessions", ["client_id"], :name => "index_my_studio_sessions_on_client_id"
  add_index "my_studio_sessions", ["studio_id"], :name => "index_my_studio_sessions_on_studio_id"

  create_table "part_layouts", :force => true do |t|
    t.integer  "part_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_layouts", ["part_id"], :name => "index_part_layouts_on_part_id"

  create_table "piece_layouts", :force => true do |t|
    t.integer  "part_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "piece_layouts", ["part_id"], :name => "index_piece_layouts_on_part_id"

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

  create_table "studios", :force => true do |t|
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip_code"
    t.integer  "country_id"
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
    t.integer  "studio_id"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.string   "friendly_name"
    t.string   "email",                                 :default => "", :null => false
    t.string   "phone_number"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "state"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip_code"
    t.integer  "country_id"
    t.string   "customer_cim_id"
    t.string   "password_salt"
    t.string   "crypted_password"
    t.string   "perishable_token"
    t.string   "persistence_token"
    t.string   "access_token"
    t.integer  "comments_count",                        :default => 0
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["access_token"], :name => "index_users_on_access_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["studio_id"], :name => "index_users_on_studio_id"

end
