require 'spec_helper'

describe Shopping::Cart do

  context "factories" do

    it 'has a shopping_cart' do
      r = create(:shopping_cart)
      r.purchase.should be_nil
      r.address.should be_nil
      r.shipping.should be_nil
      r.items.size.should == 1
    end

    context "aliases and traits" do

      it 'has a with_address' do
        r = create(:cart, :with_address)
        r.should be_persisted
        r.address.should be_persisted
        r.purchase.should be_nil
        r.shipping.should be_nil
        r.items.size.should == 1
      end
      it 'has a with_purchase' do
        # cannot do this
        # to create a purchase on a cart the
        # cart must be saved to pull the totals out
        # and the totals are needed to save
        # THIS IS VERY WEIRD.
        # One of those I have no idea how this is working things
        #r = create(:cart, :with_purchase)
        #r.should be_persisted
        #r.address.should be_persisted
        #r.purchase.should be_persisted
        #r.shipping.should be_nil
        #r.items.size.should == 1
      end
      it 'has a with_shipping' do
        r = create(:cart, :with_shipping)
        r.should be_persisted
        r.address.should be_nil
        r.purchase.should be_nil
        r.shipping.should be_persisted
        r.items.size.should == 1
      end

    end
  end

end
