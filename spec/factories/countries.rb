FactoryGirl.define do
                                      #create_table "countries", :force => true do |t|
  #  t.string "name"
  #  t.string "abbreviation", :limit => 5
  #end
  factory :country do
    name 'United States'
    abbreviation 'USA'
  end

end