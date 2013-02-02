# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_customer_item, class: 'Admin::Customer::Item', aliases: [:item] do

    offer {build(:offer)}
    part  {build(:part)}

    trait :with_item_sides do
      before :create do |item|
        FactoryGirl.create_list :item_side, 2, item: item, part: item.part
      end
    end
  end
end
