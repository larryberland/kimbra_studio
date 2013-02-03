FactoryGirl.define do

  #create_table "shopping_purchases", :force => true do |t|
  #  t.integer  "cart_id"
  #  t.decimal  "tax"
  #  t.decimal  "total"
  #  t.string   "stripe_card_token"
  #  t.string   "stripe_response_id"
  #  t.string   "stripe_paid"
  #  t.string   "stripe_fee"
  #  t.integer  "total_cents"
  #  t.datetime "purchased_at"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #  t.text     "tax_description"
  #end

  factory :shopping_purchase, class: 'Shopping::Purchase', aliases: [:purchase] do

    # need to have a cart with an address and an item with a price
    cart {create(:cart, :with_address)}
    #Rails.logger.info("built the cart")
    # calculated data
    #tax 3.33
    #total_cents 123
    # total 10.33

    purchased_at Time.now
    #tax_description

    stripe_card_token 'my_stripe_card_token'
    #stripe_response_id
    #stripe_paid
    #stripe_fee
    before :create do |purchase, evaluator|
      puts "purchase create: cart=>:#{purchase.cart}"
      puts "purchase create: address:=>#{purchase.cart.address}"
      raise "should have an item" if purchase.cart.items.size < 1
      FactoryGirl.create(:address, cart: purchase.cart) if (purchase.cart.address.nil?)
    end

  end
end
