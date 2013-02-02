FactoryGirl.define do

  #create_table "prospects", :force => true do |t|
  #  t.string   "email"
  #  t.datetime "created_at", :null => false
  #  t.datetime "updated_at", :null => false
  #end

  factory :prospect do
    sequence(:email) {|n| "JaneProspect#{n}@Email.com" }

  end

end