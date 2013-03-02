require 'spec_helper'

describe Shopping::Purchase do

  context 'factories' do
    it 'has a shopping_purchase' do
      sc_count = Shopping::StripeCard.count
      r = create(:shopping_purchase)
      r.should be_persisted
      r.cart.should be_persisted
      Shopping::StripeCard.count.should == sc_count+1
      r.stripe_card.should be_persisted
      r.cart.invoice_amount > 1
      r.stripe_response_id.should_not be_nil
      r.stripe_paid.should == true
      r.stripe_fee.should_not be_nil
      r.paid_amount.should == r.cart.invoice_amount
    end

  end

end
