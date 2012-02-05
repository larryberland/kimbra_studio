class CreateAdminCustomerItemSides < ActiveRecord::Migration
  def change
    create_table :admin_customer_item_sides do |t|
      t.references :item
      t.references :part
      t.references :portrait
      t.references :face
      t.datetime :changed_layout_at
      t.string :image_stock
      t.string :image_custom

      t.timestamps
    end
  end
end
