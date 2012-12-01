class AddSizeToAdminCustomerItemSides < ActiveRecord::Migration
  def change
    add_column :admin_customer_item_sides, :x, :integer
    add_column :admin_customer_item_sides, :y, :integer
    add_column :admin_customer_item_sides, :w, :integer
    add_column :admin_customer_item_sides, :h, :integer
  end
end
