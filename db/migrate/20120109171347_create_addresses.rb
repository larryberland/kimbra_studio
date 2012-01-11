class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :address_types do |t|
      t.string :name, :limit => 64, :null => false
      t.string :description
    end
    add_index :address_types, :name

    create_table :addresses do |t|
      t.integer :address_type_id
      t.string "first_name"
      t.string "last_name"
      t.string 'addressable_type', :null => false
      t.integer 'addressable_id', :null => false
      t.string "address1", :null => false
      t.string "address2"
      t.string "city", :null => false
      t.integer "state_id"
      t.string "state_name"
      t.string "zip_code", :null => false
      t.integer "phone_id"
      t.boolean "default", :default => false
      t.boolean "billing_default", :default => false
      t.boolean 'active', :default => true
      t.timestamps
    end

    add_index :addresses, :state_id
    add_index :addresses, :addressable_id
    add_index :addresses, :addressable_type

    remove_column :studios, :address_1
    remove_column :studios, :address_2
    remove_column :studios, :city
    remove_column :studios, :state
    remove_column :studios, :zip
    remove_column :studios, :country

  end

  def self.down
    drop_table :addresses
    drop_table :address_types

    add_column :studios, :address_1, :string
    add_column :studios, :address_2, :string
    add_column :studios, :city, :string
    add_column :studios, :state, :string
    add_column :studios, :zip, :string
    add_column :studios, :country, :string
  end
end
