require 'spec_helper'

describe Admin::Customer::Friend do

  it 'has a valid factory' do
    r = create(:admin_customer_friend)
    r.should be_persisted
    r.name.should_not be_nil
    r.email.should_not be_nil
  end

  context 'ar validations' do
    it 'requires a name' do
      build(:admin_customer_friend, name: nil).should_not be_valid
    end
  end
end
