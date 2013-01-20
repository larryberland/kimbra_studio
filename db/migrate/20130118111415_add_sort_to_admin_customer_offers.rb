class AddSortToAdminCustomerOffers < ActiveRecord::Migration

  def up
    add_column :admin_customer_offers, :sort, :integer, default: 0
    Admin::Customer::Offer.reset_column_information
    Admin::Customer::Email.all.each do |email|
      puts "updating email #{email.id}"
      email.offers.sort{|a,b|  b.id <=> a.id}.each_with_index do |offer,index|
        offer.update_attribute :sort, index
        puts "  offer: #{offer.id}"
      end
    end
  end

  def down
    remove_column :admin_customer_offers, :sort
  end

end