class AddSortToAdminCustomerOffers < ActiveRecord::Migration

  def change
    add_column :admin_customer_offers, :sort, :integer, default: 0
  end

end