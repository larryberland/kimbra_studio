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
  factory :my_studio_session, class: 'MyStudio::Session' do
    active true
    sequence(:name) { |n| "Jane Doe Session#{n}" }
    category { create(:category) }
    client { create(:my_studio_client) }

    studio do
      create(:studio)
    end

    finished_uploading_at nil

    ignore do
      portraits_count 1
      emails_count 1
    end

    trait :with_portraits do
      after :create do |session, evaluator|
        FactoryGirl.create_list :portrait, evaluator.portraits_count, my_studio_session: session
      end
    end

    trait :with_emails do
      after :create do |session, evaluator|
        FactoryGirl.create_list :email, evaluator.emails_count, my_studio_session: session
      end
    end

  end
end
