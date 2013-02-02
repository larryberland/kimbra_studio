FactoryGirl.define do
                         #create_table "states", :force => true do |t|
  #  t.string  "name",                          :null => false
  #  t.string  "abbreviation",     :limit => 5, :null => false
  #  t.string  "described_as"
  #  t.integer "country_id",                    :null => false
  #  t.integer "shipping_zone_id",              :null => false
  #end
  factory :state do
    name 'Montana'
    abbreviation 'MT'
    described_as 'State'
    association :country
    shipping_zone_id 1  # currently not supported so set all to 1
  end

end