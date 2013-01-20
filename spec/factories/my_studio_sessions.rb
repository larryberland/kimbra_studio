# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "my_studio_sessions", :force => true do |t|
  #  t.string   "name"
  #  t.date     "session_at"
  #  t.boolean  "active",                :default => true
  #  t.integer  "studio_id"
  #  t.integer  "client_id"
  #  t.integer  "category_id"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #  t.datetime "finished_uploading_at"
  #end
  factory :my_studio_session, :class => 'MyStudio::Session' do
    active true
    sequence(:name) { |n| "Jane Doe Session#{n}" }
    category { build(:category) }
    client { build(:my_studio_client) }
    studio { build(:studio) }
    finished_uploading_at nil

  end
end
