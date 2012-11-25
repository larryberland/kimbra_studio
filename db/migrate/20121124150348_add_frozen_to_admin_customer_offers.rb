class AddFrozenToAdminCustomerOffers < ActiveRecord::Migration

  def change
    add_column :admin_customer_offers, :frozen_offer, :boolean, default: false
  end

end