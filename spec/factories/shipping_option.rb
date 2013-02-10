FactoryGirl.define do

  factory :shipping_option do
    name {ShippingOption::OPTIONS.first[0]}
    total_cents {ShippingOption::OPTIONS.first[1]}
    description {ShippingOption::OPTIONS.first[2]}
  end

end