class RemoveUnusedTables < ActiveRecord::Migration
  def up
    drop_table :orders
    drop_table :order_items
    drop_table :store_credits
    drop_table :phones
    drop_table :phone_types
    drop_table :addresses
    drop_table :address_types
    drop_table :physical_addresses
    drop_table :mailing_addresses
    drop_table :payment_profiles
  end

  def down
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

    create_table :store_credits do |t|
      t.decimal :amount, :default => 0.0
      t.references :user

      t.timestamps
    end
    add_index :store_credits, :user_id

    create_table :mailing_addresses do |t|

      t.timestamps
    end

    create_table :physical_addresses do |t|

      t.timestamps
    end

    create_table :address_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    create_table :addresses do |t|
      t.references :address_type
      t.string :first_name
      t.string :last_name
      t.string :addressable_type, :null => false
      t.references :addressable, :null => false
      t.string :address1
      t.string :address2
      t.string :city, :null => false
      t.references :state
      t.string :zip_code, :null => false
      t.references :phone
      t.string :alternate_phone
      t.boolean :default, :default => false
      t.boolean :billing_default, :default => false
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :addresses, :address_type_id
    add_index :addresses, :addressable_id
    add_index :addresses, :state_id

    create_table :phone_types do |t|
      t.string :name

      t.timestamps
    end

    create_table :phones do |t|
      t.references :phone_type
      t.string :number
      t.string :phoneable_type
      t.references :phoneable
      t.boolean :primary

      t.timestamps
    end
    add_index :phones, :phone_type_id
    add_index :phones, :phoneable_id

    create_table :payment_profiles do |t|
      t.references :user
      t.references :address
      t.string :payment_cim_id
      t.boolean :default
      t.boolean :active
      t.string :last_digits
      t.string :month
      t.string :year
      t.string :cc_type
      t.string :first_name
      t.string :last_name
      t.string :card_name

      t.timestamps
    end
    add_index :payment_profiles, :user_id
    add_index :payment_profiles, :address_id

  end
end
