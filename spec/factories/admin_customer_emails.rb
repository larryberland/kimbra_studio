# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "admin_customer_emails", :force => true do |t|
  #  t.integer  "my_studio_session_id"
  #  t.boolean  "active",               :default => true
  #  t.text     "message"
  #  t.string   "tracking"
  #  t.string   "activation_code"
  #  t.datetime "generated_at"
  #  t.datetime "sent_at"
  #  t.datetime "opened_at"
  #  t.datetime "visited_at"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end
  factory :admin_customer_email, class: 'Admin::Customer::Email', aliases: [:email] do
    association :my_studio_session, factory: :my_studio_session, strategy: :create
    active true
    activation_code nil
    generated_at nil
    sent_at nil
    opened_at nil
    visited_at nil

    trait :with_friend do
      after :create do |email|
        FactoryGirl.create_list :friend, 1, email: email
      end
    end
    trait :with_offer do
      after :create do |email|
        FactoryGirl.create_list :offer, 1, email: email
      end
    end
    trait :with_cart do
      after :create do |email|
        FactoryGirl.create_list :cart, 1, email: email
      end
    end
  end

  # create an offer_email with friends, carts, and offers
  factory :offer_email, class: 'Admin::Customer::Email' do
    association :my_studio_session, factory: :my_studio_session, strategy: :create
    active true
    activation_code nil
    generated_at nil
    sent_at nil
    opened_at nil
    visited_at nil

    factory :offer_email_with_offer do
      after_create do |email, evaluator|
        piece = build(:admin_merchandise_piece)
        offer = build(:admin_customer_offer, piece: piece, email: email)
        Factory.create_list(:offers, 1, offer: offer)
      end
    end
    trait :with_cart do
      after :create do |email|
        FactoryGirl.create_list :cart, 1, email: email
      end
    end

  end
end
