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

    # need to have a cart with an address and an item with a price
    cart do
      puts "purchase create a cart"
      create(:cart, :with_address)
    end
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
      card = {
          number:          '4242424242424242',
          cvc:             '123',
          expMonth:        '05',
          expYear:         '2015',
          name:            purchase.cart.address.name,
          address_line1:   purchase.cart.address.address1,
          address_line2:   purchase.cart.address.address2,
          address_state:   purchase.cart.address.state_stripe,
          address_zip:     purchase.cart.address.zip_code,
          address_country: purchase.cart.address.country_stripe
      }
      res = Stripe.createToken(card, purchase.cart.invoice_amount)
      puts "stripe res:#{res.inspect}"


    end

  end
end
