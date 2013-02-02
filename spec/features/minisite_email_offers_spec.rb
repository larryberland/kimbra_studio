require 'spec_helper'

describe "MinisiteEmailOffers" do

  before(:all) do
    @email = Store::setup
  end

  context 'client views suggestions page' do

    before(:each) do
      visit minisite_email_offers_path(@email)
    end

    it "adds offer to cart", :js => true do

      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers

      #<button type="submit"
      #        title="Click to Add Piece to My Shopping Cart."
      #        name="button"
      #        id="259"
      #        class="btn-small btn-primary btn">
      #  <i class="icon-plus-sign icon-white"></i>
      #   Add to Cart
      #</button>
      click_button "Add to Cart" # any button with Add to Cart

      text = "Added #{@email.offers.first.name} to your Shopping cart"
      page.should have_content(Regexp.new(text))

    end

    it 'adjust photo' do

      #save_and_open_page

      v = find_button("adjust#{@email.offers.first.id}")

      #click_button " Adjust Photo and add to My Collection" # any button with Add to Cart
      click_button "adjust#{@email.offers.first.id}"

      page.should have_content('Move or resize selection by dragging')

    end
  end
end
