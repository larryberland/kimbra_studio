FactoryGirl.define do

  factory :shipping_option do

    ignore do
      index 0
      attrs {ShippingOption.options(index)}
    end

    name { attrs[:name] }
    cost_cents { attrs[:cost_cents] }
    description { attrs[:description] }

  end

end