require 'spec_helper'

describe Admin::Customer::Email do

  context "factories" do
    before do
      @message = 'rspec studio name suggests heirloom jewelry for Jane Doe Client.'
      @email = 'janedoe@email.com'
    end

    it 'has a admin_customer_email' do
      r = create(:admin_customer_email)
      r.should be_persisted
      r.tracking.should_not be_nil
      r.message.should == @message
      r.my_studio_session.client.email.should == @email
      r.carts.size.should == 0
      r.friends.size.should == 0
      r.offers.size.should == 0
    end

    context 'aliases and traits' do

      it 'has a offer_email' do
        r = create(:offer_email)
        r.should be_persisted
        r.tracking.should_not be_nil
        r.message.should == @message
        r.my_studio_session.client.email.should == @email
      end

      it 'has a trait with_cart' do
        r = create(:email, :with_cart)
        r.should be_persisted
        r.tracking.should_not be_nil
        r.message.should == @message
        r.my_studio_session.client.email.should == @email
        r.carts.size.should == 1
        r.friends.size.should == 0
        r.offers.size.should == 0
      end

      it 'has a trait with_friend' do
        r = create(:email, :with_friend)
        r.should be_persisted
        r.tracking.should_not be_nil
        r.message.should == @message
        r.my_studio_session.client.email.should == @email
        r.carts.size.should == 0
        r.friends.size.should == 1
        r.offers.size.should == 0
      end

      it 'has a trait with_offer' do
        r = create(:email, :with_offer)
        r.should be_persisted
        r.tracking.should_not be_nil
        r.message.should == @message
        r.my_studio_session.client.email.should == @email
        r.carts.size.should == 0
        r.friends.size.should == 0
        r.offers.size.should == 1
      end
    end
  end

  context 'ar validations' do
    # no validatons currently
  end

  context 'class methods' do
    it 'creates a gypsy email' do
      # Admin::Customer::Email.create_gypsy

    end

    it 'sends an Offer Email' do
      # Admin::Customer::Email.SendOfferEmails
    end

    it 'generates an Offer Email' do
      # Admin::Customer::Email.generate(session_id)
    end

    it 'creates a friend for this Offer Email' do

    end
  end
end
