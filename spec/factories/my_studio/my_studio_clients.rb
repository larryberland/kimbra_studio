# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "my_studio_clients", :force => true do |t|
  #  t.string   "name"
  #  t.string   "email"
  #  t.string   "phone_number"
  #  t.boolean  "active",       :default => true
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end

  factory :my_studio_client, class: 'MyStudio::Client', aliases: [:client] do
    name  "Jane Doe Client"
    #email "JaneDoe@Email.com"
    email { MyStudio::Client.find_or_create_by_email("JaneDoe@Email.com").email }
    phone_number '406.765.1234'
    active true
  end
end
