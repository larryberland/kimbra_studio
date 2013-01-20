require 'spec_helper'

describe Studio do

  before(:each) do
    @s = create(:studio) # use factory_girl

    @s.should be_persisted
  end

  it "can be instantiated" do
    Studio.new.should be_an_instance_of(Studio)
  end


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
