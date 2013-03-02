require 'spec_helper'

describe Shopping::Shipping do

  context 'factories' do
    it 'has a shopping_shipping' do
      r = create(:shopping_shipping)
      r.should be_persisted
      r.cart.should be_persisted
      r.shipping_option_name.should == ShippingOption.options(0)[:name]
      r.amount.should == ShippingOption.options(0)[:cost_cents]
    end

    context 'aliases and traits' do

      it 'has a shipping' do
        cart = create(:cart)
        count = Shopping::Cart.count
        r = create(:shipping, index: 1, cart_id: cart.id)
        r.should be_persisted
        r.shipping_option_name.should == ShippingOption.options(1)[:name]
        r.amount.should == ShippingOption.options(1)[:cost_cents]
        Shopping::Cart.count.should == count
      end
    end
  end

  context 'ar validations' do
    it 'requires a cart' do
      build(:shipping, cart: nil).should_not be_valid
    end

    it 'requires all fields' do
      build(:shipping, tracking: nil).should_not be_valid
      # todo: need a checksum validation check
      #       not sure what this is?
    end
  end


end
