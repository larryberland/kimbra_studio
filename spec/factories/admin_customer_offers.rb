# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_customer_offer, class: 'Admin::Customer::Offer', aliases: [:offer] do
    email {build(:email, :with_friend)}
    piece {build{:piece}}
    friend {email.friends.first}
  end
end
