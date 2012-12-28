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

ActiveRecord::Schema.define(:version => 20121228194237) do

  create_table "address_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.integer  "address_type_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "addressable_type",                    :null => false
    t.integer  "addressable_id",                      :null => false
    t.string   "address1"
    t.string   "address2"
    t.string   "city",                                :null => false
    t.integer  "state_id"
    t.string   "zip_code",                            :null => false
    t.integer  "phone_id"
    t.string   "alternate_phone"
    t.boolean  "default",          :default => false
    t.boolean  "billing_default",  :default => false
    t.boolean  "active",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["address_type_id"], :name => "index_addresses_on_address_type_id"
  add_index "addresses", ["addressable_id"], :name => "index_addresses_on_addressable_id"
  add_index "addresses", ["state_id"], :name => "index_addresses_on_state_id"

  create_table "admin_customer_emails", :force => true do |t|
    t.integer  "my_studio_session_id"
    t.boolean  "active",               :default => true
    t.text     "message"
    t.string   "tracking"
    t.string   "activation_code"
    t.datetime "generated_at"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "visited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_customer_emails", ["my_studio_session_id"], :name => "index_admin_customer_emails_on_my_studio_session_id"
  add_index "admin_customer_emails", ["tracking"], :name => "index_admin_customer_emails_on_tracking"

  create_table "admin_customer_friends", :force => true do |t|
    t.string   "name"
    t.integer  "email_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "admin_customer_friends", ["email_id"], :name => "index_admin_customer_friends_on_email_id"

  create_table "admin_customer_item_sides", :force => true do |t|
    t.integer  "item_id"
    t.integer  "part_id"
    t.integer  "portrait_id"
    t.datetime "changed_layout_at"
    t.string   "image_stock"
    t.string   "image_custom"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "x"
    t.integer  "y"
    t.integer  "w"
    t.integer  "h"
  end

  create_table "admin_customer_items", :force => true do |t|
    t.integer  "offer_id"
    t.integer  "part_id"
    t.boolean  "photo",      :default => true
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order"
  end

  add_index "admin_customer_items", ["offer_id"], :name => "index_admin_customer_items_on_offer_id"
  add_index "admin_customer_items", ["part_id"], :name => "index_admin_customer_items_on_part_id"

  create_table "admin_customer_offers", :force => true do |t|
    t.integer  "email_id"
    t.integer  "piece_id"
    t.string   "tracking"
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
    t.boolean  "frozen_offer",    :default => false
    t.boolean  "client"
    t.integer  "friend_id"
  end

  add_index "admin_customer_offers", ["email_id"], :name => "index_admin_customer_offers_on_email_id"
  add_index "admin_customer_offers", ["piece_id"], :name => "index_admin_customer_offers_on_piece_id"
  add_index "admin_customer_offers", ["tracking"], :name => "index_admin_customer_offers_on_tracking"

  create_table "admin_merchandise_parts", :force => true do |t|
    t.integer  "piece_id"
    t.integer  "portrait_id"
    t.string   "image_part"
    t.string   "image"
    t.integer  "order",             :default => 0
    t.boolean  "photo",             :default => true
    t.integer  "image_width"
    t.integer  "image_height"
    t.integer  "image_part_width"
    t.integer  "image_part_height"
    t.boolean  "active",            :default => true
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
    t.boolean  "photo"
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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "facebook_users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.string   "name"
    t.string   "image_url"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

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

  create_table "mailing_addresses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "commission_rate",    :default => 15
  end

  add_index "my_studio_infos", ["studio_id"], :name => "index_my_studio_infos_on_studio_id"

  create_table "my_studio_minisites", :force => true do |t|
    t.integer  "studio_id"
    t.string   "bgcolor"
    t.string   "image"
    t.string   "font_family"
    t.string   "font_color"
    t.string   "theme"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_width"
    t.integer  "image_height"
  end

  add_index "my_studio_minisites", ["studio_id"], :name => "index_my_studio_minisites_on_studio_id"

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

  add_index "my_studio_portraits", ["created_at"], :name => "index_my_studio_portraits_on_created_at"
  add_index "my_studio_portraits", ["my_studio_session_id"], :name => "index_my_studio_portraits_on_my_studio_session_id"

  create_table "my_studio_sessions", :force => true do |t|
    t.string   "name"
    t.date     "session_at"
    t.boolean  "active",                :default => true
    t.integer  "studio_id"
    t.integer  "client_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "finished_uploading_at"
  end

  add_index "my_studio_sessions", ["category_id"], :name => "index_my_studio_sessions_on_category_id"
  add_index "my_studio_sessions", ["client_id"], :name => "index_my_studio_sessions_on_client_id"
  add_index "my_studio_sessions", ["studio_id"], :name => "index_my_studio_sessions_on_studio_id"

  create_table "order_items", :force => true do |t|
    t.decimal  "price"
    t.decimal  "total"
    t.integer  "order_id"
    t.string   "state"
    t.integer  "tax_rate_id"
    t.integer  "shipping_rate_id"
    t.integer  "shipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["shipment_id"], :name => "index_order_items_on_shipment_id"
  add_index "order_items", ["shipping_rate_id"], :name => "index_order_items_on_shipping_rate_id"
  add_index "order_items", ["tax_rate_id"], :name => "index_order_items_on_tax_rate_id"

  create_table "orders", :force => true do |t|
    t.string   "number"
    t.string   "ip_address"
    t.string   "email"
    t.string   "state"
    t.integer  "user_id"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.integer  "coupon_id"
    t.boolean  "active",           :default => true
    t.boolean  "shipped",          :default => false
    t.integer  "shipment_counter", :default => 0
    t.datetime "calculated_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["bill_address_id"], :name => "index_orders_on_bill_address_id"
  add_index "orders", ["coupon_id"], :name => "index_orders_on_coupon_id"
  add_index "orders", ["ship_address_id"], :name => "index_orders_on_ship_address_id"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "part_layouts", :force => true do |t|
    t.integer  "part_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "part_layouts", ["part_id"], :name => "index_part_layouts_on_part_id"

  create_table "payment_profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "address_id"
    t.string   "payment_cim_id"
    t.boolean  "default"
    t.boolean  "active"
    t.string   "last_digits"
    t.string   "month"
    t.string   "year"
    t.string   "cc_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_profiles", ["address_id"], :name => "index_payment_profiles_on_address_id"
  add_index "payment_profiles", ["user_id"], :name => "index_payment_profiles_on_user_id"

  create_table "phone_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", :force => true do |t|
    t.integer  "phone_type_id"
    t.string   "number"
    t.string   "phoneable_type"
    t.integer  "phoneable_id"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["phone_type_id"], :name => "index_phones_on_phone_type_id"
  add_index "phones", ["phoneable_id"], :name => "index_phones_on_phoneable_id"

  create_table "physical_addresses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "avatar"
    t.integer  "width",                :default => 0
    t.integer  "height",               :default => 0
    t.boolean  "active",               :default => true
    t.integer  "my_studio_session_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "pictures", ["my_studio_session_id"], :name => "index_pictures_on_my_studio_session_id"

  create_table "piece_layouts", :force => true do |t|
    t.integer  "part_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "piece_layouts", ["part_id"], :name => "index_piece_layouts_on_part_id"

  create_table "prospects", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string "name", :limit => 30, :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sent_emails", :force => true do |t|
    t.string   "email"
    t.string   "subject"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sent_emails", ["created_at"], :name => "index_sent_emails_on_created_at"
  add_index "sent_emails", ["email"], :name => "index_sent_emails_on_email"

  create_table "shipping_options", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "cost_cents"
    t.integer  "sort_order"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "shopping_addresses", :force => true do |t|
    t.integer  "cart_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip_code"
    t.string   "country",    :default => "USA"
    t.string   "email"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "phone"
  end

  add_index "shopping_addresses", ["state_id"], :name => "index_shopping_addresses_on_state_id"

  create_table "shopping_carts", :force => true do |t|
    t.integer  "email_id"
    t.string   "tracking"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shopping_carts", ["email_id"], :name => "index_shopping_carts_on_email_id"

  create_table "shopping_items", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "offer_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "option"
    t.string   "option_selected"
  end

  add_index "shopping_items", ["cart_id"], :name => "index_shopping_items_on_cart_id"
  add_index "shopping_items", ["offer_id"], :name => "index_shopping_items_on_offer_id"

  create_table "shopping_purchases", :force => true do |t|
    t.integer  "cart_id"
    t.decimal  "tax"
    t.decimal  "total"
    t.string   "stripe_card_token"
    t.string   "stripe_response_id"
    t.string   "stripe_paid"
    t.string   "stripe_fee"
    t.integer  "total_cents"
    t.datetime "purchased_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "tax_description"
  end

  add_index "shopping_purchases", ["cart_id"], :name => "index_shopping_purchases_on_cart_id"

  create_table "shopping_shippings", :force => true do |t|
    t.integer  "cart_id"
    t.string   "shipping_option"
    t.integer  "total_cents"
    t.string   "tracking"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "shopping_stripe_cards", :force => true do |t|
    t.integer  "purchase_id"
    t.string   "country"
    t.string   "cvc_check"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.string   "last4"
    t.string   "stripe_type"
    t.string   "stripe_object"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "shopping_stripe_cards", ["purchase_id"], :name => "index_shopping_stripe_cards_on_purchase_id"

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

  create_table "store_credits", :force => true do |t|
    t.decimal  "amount",     :default => 0.0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "store_credits", ["user_id"], :name => "index_store_credits_on_user_id"

  create_table "stories", :force => true do |t|
    t.string   "session_id"
    t.text     "referer"
    t.string   "ip_address"
    t.string   "browser"
    t.string   "version"
    t.string   "os"
    t.string   "name"
    t.integer  "studio_id"
    t.integer  "client_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stories", ["client_id"], :name => "index_stories_on_client_id"
  add_index "stories", ["created_at"], :name => "index_stories_on_created_at"
  add_index "stories", ["ip_address"], :name => "index_stories_on_ip_address"
  add_index "stories", ["name"], :name => "index_stories_on_name"
  add_index "stories", ["session_id"], :name => "index_stories_on_session_id"
  add_index "stories", ["studio_id"], :name => "index_stories_on_studio_id"

  create_table "storylines", :force => true do |t|
    t.integer  "story_id"
    t.string   "session_id"
    t.string   "url"
    t.string   "description"
    t.integer  "seconds"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "storylines", ["session_id"], :name => "index_storylines_on_session_id"
  add_index "storylines", ["story_id"], :name => "index_storylines_on_story_id"
  add_index "storylines", ["url"], :name => "index_storylines_on_url"

  create_table "studio_emails", :force => true do |t|
    t.integer  "studio_id"
    t.string   "email_name"
    t.datetime "sent_at"
    t.datetime "clicked_through_at"
  end

  add_index "studio_emails", ["clicked_through_at"], :name => "index_studio_emails_on_clicked_through_at"
  add_index "studio_emails", ["email_name"], :name => "index_studio_emails_on_email_name"
  add_index "studio_emails", ["sent_at"], :name => "index_studio_emails_on_sent_at"
  add_index "studio_emails", ["studio_id"], :name => "index_studio_emails_on_studio_id"

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
    t.string   "sales_status", :default => "none"
    t.text     "sales_notes"
  end

  create_table "unsubscribes", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "unsubscribes", ["email"], :name => "index_unsubscribes_on_email"

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
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "formatted_address"
    t.date     "joined_on"
    t.integer  "csv_row"
    t.string   "first_pass"
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

  create_table "zip_code_taxes", :force => true do |t|
    t.string  "state"
    t.string  "zip_code"
    t.string  "tax_region_name"
    t.string  "tax_region_code"
    t.decimal "combined_rate",   :precision => 7, :scale => 6
    t.decimal "state_rate",      :precision => 7, :scale => 6
    t.decimal "county_rate",     :precision => 7, :scale => 6
    t.decimal "city_rate",       :precision => 7, :scale => 6
    t.decimal "special_rate",    :precision => 7, :scale => 6
  end

  add_index "zip_code_taxes", ["zip_code"], :name => "index_zip_code_taxes_on_zip_code"

end
