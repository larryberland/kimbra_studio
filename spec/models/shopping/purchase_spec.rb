require 'spec_helper'

describe Shopping::Purchase do

  context 'factories' do
    it 'has a shopping_purchase' do
      r = create(:shopping_purchase)
      r.should be_persisted
    end

    context 'aliases and traits' do

      it 'has a address' do
        r = create(:purchase)
        r.should be_persisted
      end
    end
  end

end
