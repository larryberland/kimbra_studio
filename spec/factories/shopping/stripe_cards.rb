FactoryGirl.define do

  #create_table "shopping_stripe_cards", :force => true do |t|
  #  t.integer  "purchase_id"
  #  t.string   "country"
  #  t.string   "cvc_check"
  #  t.integer  "exp_month"
  #  t.integer  "exp_year"
  #  t.string   "last4"
  #  t.string   "stripe_type"
  #  t.string   "stripe_object"
  #  t.datetime "created_at",    :null => false
  #  t.datetime "updated_at",    :null => false
  #end

  factory :shopping_stripe_card, class: 'Shopping::StripeCard', aliases: [:stripe_card] do

    ignore do
      card_number '424242424242424242'
      cvc '123'
      exp_month '01'
      exp_year '2015'
    end

    before (:create) do |stripe_card, evaluator|
      raise "forget to set purchase?" if stripe_card.purchase.nil?
      # send request off to Stripe
      card = {number: evaluator.card_number,
              cvc: evaluator.cvc,
              expMonth: evaluator.month,
              expYear: evaluator.year}
      amount = stripe_card.purchase.total
        #number: $('#card_number').val()
        #cvc: $('#card_code').val()
        #expMonth: $('#card_month').val()
        #expYear: $('#card_year').val()
        #name: $('#shopping_purchase_cart_address_attributes_name').val()
        #address_line1: $('#shopping_purchase_cart_address_attributes_address1').val()
        #address_line2: $('#shopping_purchase_cart_address_attributes_address2').val()
        #address_state: $('#shopping_purchase_cart_address_attributes_state_stripe').val()
        #address_zip: $('#shopping_purchase_cart_address_attributes_zip_code').val()
        #address_country: $('#shopping_purchase_cart_address_attributes_country_stripe').val()
      Stripe.createToken(card, amount)

    end

  end
end
