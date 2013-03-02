require 'spec_helper'

describe Shopping::Address do

  context 'factories' do
    it 'has a shopping_address' do
      r = create(:shopping_address)
      r.should be_persisted
      r.cart.should be_persisted
    end

    context 'aliases and traits' do

      it 'has a address' do
        cart = create(:cart)
        count = Shopping::Cart.count
        r = create(:address, cart_id: cart.id, address2: 'PO Box 123')
        r.should be_persisted
        r.cart.should be_persisted
        Shopping::Cart.count.should == count
        r.address2.should == 'PO Box 123'
      end
    end
  end

  context 'ar validations' do
    it 'requires a cart' do
      build(:address, cart: nil).should_not be_valid
    end

    it 'requires all fields' do
      build(:address, first_name: nil).should_not be_valid
      build(:address, last_name: nil).should_not be_valid
      build(:address, address1: nil).should_not be_valid
      build(:address, city: nil).should_not be_valid
      build(:address, state: nil).should_not be_valid
      build(:address, zip_code: nil).should_not be_valid
    end
  end


end
