# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_customer_friend, :class => 'Admin::Customer::Friend' do
    name "MyString"
    email nil
  end
end
