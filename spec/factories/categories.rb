FactoryGirl.define do

  #create_table "categories", :force => true do |t|
  #  t.string   "name"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end
  factory :category do
    name Category::NAMES.last
  end
end
