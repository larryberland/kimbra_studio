require 'spec_helper'

describe Shopping::Cart do

  context 'factories' do

    it 'has a shopping_cart' do
      r = Shopping::Cart.find_by_id(create(:shopping_cart).id)
      r.purchase.should be_nil
      r.address.should be_nil
      r.shipping.should be_nil
      r.items.size.should == 1
    end

    context 'aliases and traits' do

      it 'has a with_address' do
        r = Shopping::Cart.find_by_id(create(:cart, :with_address).id)
        r.should be_persisted
        r.address.should be_persisted
        r.purchase.should be_nil
        r.shipping.should be_nil
        r.items.size.should == 1
      end

      it 'has a with_purchase' do
        r = Shopping::Cart.find_by_id(create(:cart, :with_purchase).id)
        r.should be_persisted
        r.address.should be_persisted
        r.shipping.should be_persisted
        r.purchase.should be_persisted
        r.items.size.should == 1
      end

      it 'has a with_shipping' do
        # reloading cart will pull in the items
        # r does not currently have them??
        r = Shopping::Cart.find_by_id(create(:cart, :with_shipping).id)

        r.should be_persisted
        r.address.should be_nil
        r.purchase.should be_nil
        r.shipping.should be_persisted
        r.items.size.should == 1
        r.invoice_shipping_total.should > 9.0
        puts "cart:#{r.inspect}"
        r.invoice_amount == 0
      end

    end
  end

end
