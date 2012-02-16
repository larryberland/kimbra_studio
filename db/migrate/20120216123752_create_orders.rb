class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.string :ip_address
      t.string :email
      t.string :state
      t.references :user
      t.references :bill_address
      t.references :ship_address
      t.references :coupon
      t.boolean :active, :default => true
      t.boolean :shipped, :default => false
      t.integer :shipment_counter, :default => 0
      t.datetime :calculated_at
      t.datetime :completed_at

      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :bill_address_id
    add_index :orders, :ship_address_id
    add_index :orders, :coupon_id
  end
end
