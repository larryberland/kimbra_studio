require 'spec_helper'

describe Admin::Customer::Item do
  context "factories" do
    before do
      @message = "rspec studio name suggests heirloom jewelry for Jane Doe Client."
      @email = 'janedoe@email.com'
    end

    it 'has a admin_customer_item' do
      r = create(:admin_customer_item)
      r.should be_persisted
      r.offer.should be_persisted
      r.part.should be_persisted
    end

    context "aliases and traits" do

    end
  end

  context 'ar validations' do
    # no validations currently
  end

  context 'class methods' do
  end
end
