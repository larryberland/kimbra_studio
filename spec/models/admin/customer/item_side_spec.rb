require 'spec_helper'

describe Admin::Customer::ItemSide do

  context "factories" do

    it 'has no factory' do
      # since item_sides are created through
      #  offers and items cannot create one
      #  without causing recursion
    end
  end

  context 'ar validations' do
    # no validatons currently
  end

  context 'class methods' do
  end
end
