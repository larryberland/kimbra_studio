FactoryGirl.define do

  factory :admin, class: User do
      first_name "Admin"
      last_name  "User"
      association :roles, factory: :role, strategy: :build
  end

  #create_table "studios", :force => true do |t|
  #  t.string   "name"
  #  t.string   "address_1"
  #  t.string   "address_2"
  #  t.string   "city"
  #  t.integer  "state_id"
  #  t.string   "zip_code"
  #  t.integer  "country_id"
  #  t.string   "phone_number"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end
  factory :studio do
    name 'rspec studio name'
    address_1 '322 Highland Ave'
    address_2 'Suite 123'
    city 'Plentywood'
    association :state, factory: :state, strategy: :create
    zip_code '59254'
    association :country, factory: :country, strategy: :build
    phone_number '406.765.1845'

    owner do
      if (user = User.find_by_email("Owner@Studio.com".downcase))
        user
      else
        create(:owner)
      end
    end

    info {create(:info)}
    minisite {create(:minisite)}

    # the following most likely will be added
    #   during testing
    #staffers
    #studio_emails
    #clients
    #emails
    #carts

    ignore do
      sessions_count 1
    end

    trait :with_session do
      after :create do |studio, evaluator|
        FactoryGirl.create_list :my_studio_session, evaluator.sessions_count, studio: studio
      end
    end

  end
end