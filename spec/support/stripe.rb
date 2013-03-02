RSpec.configure do |config|
  config.before do
    Stripe::Charge.stub!(:create) do
      # STRIPE:response=>#<Stripe::Charge:0x3fc349d0c07c id=ch_1O5jSFkqBFeNFp> JSON:
     {"id" => "ch_1O5jSFkqBFeNFp",
        "object" => "charge",
        "created" => 1362245729,
        "livemode" => false,
        "paid" => true,
        "amount" => 5300,
        "currency" => "usd",
        "refunded" => false,
        "fee" => 184,
        "fee_details" => [{"amount" =>184,"currency" =>"usd","type" =>"stripe_fee","description" =>"Stripe processing fees","application" => nil,"amount_refunded" =>0}],
        "card" => {"object" =>"card","last4" =>"4242","type" =>"Visa","exp_month" =>3,"exp_year" =>2013,"fingerprint" =>"9aWIRgICzoFOjgY8","country" =>"US","name" =>"larry berland","address_line1" =>"3146 Main Street","address_line2" =>"Ste 101","address_city" => nil,"address_state" =>"FL","address_zip" =>"34638-7714","address_country" =>"USA","cvc_check" =>"pass","address_line1_check" =>"pass","address_zip_check" =>"pass"},
        "failure_message" =>  nil,
        "amount_refunded" => 0,
        "customer" =>  nil,
        "invoice" =>  nil,
        "description" => "Berland Designs and Portraits By Larry Studios for test@gmail.com order =>fqx5d5ta27",
        "dispute" =>  nil,
        "disputed" => false
      }
    end
  end
end