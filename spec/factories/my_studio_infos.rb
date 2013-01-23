# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  #create_table "my_studio_infos", :force => true do |t|
  #  t.integer  "studio_id"
  #  t.boolean  "active",                :default => true
  #  t.string   "website"
  #  t.string   "email"
  #  t.string   "email_notification"
  #  t.string   "tax_ein"
  #  t.boolean  "pictage_member"
  #  t.boolean  "smug_mug_member"
  #  t.boolean  "mac_user"
  #  t.boolean  "windows_user"
  #  t.boolean  "ping_email",            :default => true
  #  t.datetime "created_at"
  #  t.datetime "updated_at"
  #  t.integer  "commission_rate",       :default => 15
  #  t.boolean  "pinterest_for_clients", :default => true
  #  t.boolean  "facebook_for_clients",  :default => true
  #end
  factory :my_studio_info, class: 'MyStudio::Info', aliases: [:info] do
    email "mystudio@email.com"
    website "wwww.mystudioinfo.com"
  end
end
