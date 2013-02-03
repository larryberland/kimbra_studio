# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "shopping_carts", :force => true do |t|
  #  t.integer  "email_id"
  #  t.string   "tracking"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end
  factory :shopping_cart, class: 'Shopping::Cart', aliases: [:cart] do
    tracking nil

    ignore do
      items_count 1
    end

    before :create do |cart, evaluator|
      puts "carts: create items"
      FactoryGirl.create_list :shopping_item, evaluator.items_count, cart: cart
    end

    trait :with_address do
      before :create do |cart, evaluator|
        puts "two"
        FactoryGirl.create(:address, cart: cart)
      end
    end

    trait :with_purchase do

      before :create do |cart, evaluator|
        puts "carts: create with_purchase "
        puts "carts: items:#{cart.items.inspect}"
        puts "carts: address:#{cart.address.inspect}"
        cart.address = FactoryGirl.build(:address, cart: nil) if cart.address.nil?
        puts "carts: create=>#{cart}"
      end

      after :create do |cart, evaluator|
        raise "missing address" if cart.address.nil?
        raise "missing cart items" if cart.items.size < 1
        puts "carts: after create=>#{cart.inspect}"
        cart.purchase = FactoryGirl.build(:purchase, cart: cart)
        cart.save!
      end
    end

    trait :with_shipping do
      before :create do |cart, evaluator|
        FactoryGirl.create(:shipping, cart: cart)
      end
    end

  end
end
