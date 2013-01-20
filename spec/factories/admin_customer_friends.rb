# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :admin_customer_friend, class: 'Admin::Customer::Friend', aliases: [:friend] do
    sequence(:name) {|n| "Jane Doe Friend#{n}" }
    email {build(:admin_customer_email)}
  end
end
