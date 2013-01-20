# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "my_studio_portraits", :force => true do |t|
  #  t.string   "image"
  #  t.string   "description"
  #  t.integer  "width",                :default => 0
  #  t.integer  "height",               :default => 0
  #  t.boolean  "active",               :default => true
  #  t.integer  "my_studio_session_id"
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #end

  factory :my_studio_portrait, class: 'MyStudio::Portrait', aliases: [:portrait] do
    my_studio_session {build(:my_studio_session)}
    description "usually the file name"

    ignore do
      # pass in a different file name in the spec/support/images/portraits directory
      #   create(:portrait, file: 'landscape.png')
      file 'portrait.png'
    end
    before(:create) do |portrait, evaluator|
      Rails.logger.info("one")
      portrait.image = File.open(Rails.root.join("spec/support/images/portraits/#{evaluator.file}").to_s)
    end

    trait :with_landscape do
      before :create do |portrait|
        Rails.logger.info("two")
        portrait.image.remove!
        portrait.image = File.open(Rails.root.join("spec/support/images/portraits/landscape.png").to_s)
      end
    end

  end
end
