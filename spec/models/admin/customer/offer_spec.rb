require 'spec_helper'

describe Admin::Customer::Offer do
  context 'factories' do
    before do
      @message = 'rspec studio name suggests heirloom jewelry for Jane Doe Client.'
      @email = 'janedoe@email.com'

    end

    it 'has a admin_customer_offer' do
      r = create(:admin_customer_offer)
      r.should be_persisted
      r.email.should be_persisted
      r.friend.should be_persisted
      r.piece.should be_persisted
      r.tracking.should_not be_nil
      r.name.should == 'Annika Charm'
      r.description.should_not be_nil
      r.image.url.should == '/images/fallback/empty_deal_image.png'
      r.image_front.url.should == '/images/fallback/empty_deal_image.png'
      r.image_back.url.should == '/images/fallback/empty_deal_image.png'

    end

    context 'aliases and traits' do

      it 'has a offer' do
        r = create(:offer)
        r.should be_persisted
        r.email.should be_persisted
        r.friend.should be_persisted
        r.piece.should be_persisted
        r.tracking.should_not be_nil
        r.name.should == 'Annika Charm'
        r.description.should_not be_nil
        r.image.url.should == '/images/fallback/empty_deal_image.png'
        r.image_front.url.should == '/images/fallback/empty_deal_image.png'
        r.image_back.url.should == '/images/fallback/empty_deal_image.png'
      end

    end
  end
end
