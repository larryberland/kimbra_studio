class AddClientToAdminCustomerOffers < ActiveRecord::Migration
  def change
    add_column :admin_customer_offers, :client, :boolean
  end
end
