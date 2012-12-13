class AddOrderToAdminCustomerItems < ActiveRecord::Migration
  def change
    add_column :admin_customer_items, :order, :integer
  end
end
