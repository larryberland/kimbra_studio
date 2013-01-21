# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  #create_table "admin_customer_offers", :force => true do |t|
  #  t.integer "email_id"
  #  t.integer "piece_id"
  #  t.string "tracking"
  #  t.string "image"
  #  t.string "image_front"
  #  t.string "image_back"
  #  t.boolean "active", :default => true
  #  t.string "name"
  #  t.text "description"
  #  t.string "custom_layout", :default => "order"
  #  t.string "activation_code"
  #  t.datetime "visited_at"
  #  t.datetime "purchased_at"
  #  t.integer "width"
  #  t.integer "height"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #  t.boolean "frozen_offer", :default => false
  #  t.boolean "client"
  #  t.integer "friend_id"
  #  t.integer "sort", :default => 0
  #end

  factory :admin_customer_offer, class: 'Admin::Customer::Offer', aliases: [:offer] do
    email { create(:email, :with_friend) }
    piece { create(:piece) }
    friend { email.friends.first }

    custom_layout 'composite'
    frozen_offer false
    client true
    sort 0
    # the following are all generated info when assembling an offer
    # image
    # image_front
    # image_back

  end
end
