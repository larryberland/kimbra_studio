# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "shopping_carts", :force => true do |t|
  #  t.integer  "email_id"
  #  t.string   "tracking"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end
  factory :shopping_cart, class: 'Shopping::Cart', aliases: [:cart] do
    email {build(:admin_customer_email)}
    tracking nil
  end
end
