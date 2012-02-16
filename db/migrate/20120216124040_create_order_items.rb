class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.decimal :price
      t.decimal :total
      t.references :order
      t.string :state
      t.references :tax_rate
      t.references :shipping_rate
      t.references :shipment

      t.timestamps
    end
    add_index :order_items, :order_id
    add_index :order_items, :tax_rate_id
    add_index :order_items, :shipping_rate_id
    add_index :order_items, :shipment_id
  end
end
