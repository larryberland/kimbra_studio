class CreateAdminCustomerItems < ActiveRecord::Migration
  def change
    create_table :admin_customer_items do |t|
      t.references :offer
      t.references :part
      t.string :image_stock
      t.string :image_item
      t.integer :width
      t.integer :height
      t.integer :item_x       # copy of part item_x
      t.integer :item_y
      t.integer :item_width
      t.integer :item_height

      t.timestamps
    end
    add_index :admin_customer_items, :offer_id
    add_index :admin_customer_items, :part_id
  end
end
