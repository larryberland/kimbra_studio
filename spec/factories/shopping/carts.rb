# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do


  #create_table "shopping_carts", :force => true do |t|
  #  t.integer  "email_id"
  #  t.string   "tracking"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end
  factory :shopping_cart, class: 'Shopping::Cart', aliases: [:cart] do

    ignore do
      items_count 1
    end

    tracking nil

    before :create do |cart, evaluator|
      # puts "CARTS add shopping_item"
      FactoryGirl.create_list :shopping_item, evaluator.items_count, cart: cart
    end

    trait :with_address do
      before :create do |cart, evaluator|
        #puts "with_address before::create"
        FactoryGirl.create(:address, cart_id: cart.id)
      end
    end

    trait :with_purchase do

      before :create do |cart, evaluator|
        #puts "carts: with_purchase before_create"
        #puts "carts: items:#{cart.items.inspect}"
        #puts "carts: address:#{cart.address.inspect}"
        cart.address = FactoryGirl.create(:address, cart: cart) if cart.address.nil?
      end

      after :create do |cart, evaluator|
        cart.items.reload
        raise 'missing address' if cart.address.nil?
        raise 'missing cart items' if cart.items.size < 1
        FactoryGirl.create(:purchase, cart: cart)
        cart.save!
      end
    end

    trait :with_shipping do
      before :create do |cart, evaluator|
        FactoryGirl.create(:shipping, cart_id: cart.id)
      end
    end

  end
end
