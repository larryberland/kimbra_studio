FactoryGirl.define do

  #create_table "shopping_purchases", :force => true do |t|
  #  t.integer  "cart_id"
  #  t.integer  "invoice_amount"
  #  t.integer  "paid_amount"
  #  t.string   "stripe_card_token"
  #  t.string   "stripe_response_id"
  #  t.string   "stripe_paid"
  #  t.string   "stripe_fee"
  #  t.datetime "purchased_at"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end

  factory :shopping_purchase, class: 'Shopping::Purchase', aliases: [:purchase] do

    cart_id do
      # for purchase we need an cart.invoice_amount so we must
      #   create the cart with and address and shipping info
      FactoryGirl.create(:cart, :with_address, :with_shipping).id
    end

    # gets created in stripe_payment callback
    # stripe_card {FactoryGirl.create(:stripe_card)}

    # calculated data
    # tax 3.33
    # total_cents 123
    # total 10.33

    purchased_at Time.now
    #tax_description

    sequence(:stripe_card_token) { |n| "Token #{ n }" }

    #stripe_response_id
    #stripe_paid
    #stripe_fee

    before :create do |purchase, evaluator|
      raise 'should have an item' if purchase.cart.items.size < 1
      raise 'should have an address' if purchase.cart.address.nil?
      raise 'should have a shipping' if purchase.cart.shipping.nil?
    end

  end
end
