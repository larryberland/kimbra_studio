class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :address_type
      t.string :first_name
      t.string :last_name
      t.string :addressable_type, :null => false
      t.references :addressable,  :null => false
      t.string :address1
      t.string :address2
      t.string :city,             :null => false
      t.references :state
      t.string :zip_code,              :null => false
      t.references :phone
      t.string :alternate_phone
      t.boolean :default,         :default => false
      t.boolean :billing_default, :default => false
      t.boolean :active,          :default => true

      t.timestamps
    end
    add_index :addresses, :address_type_id
    add_index :addresses, :addressable_id
    add_index :addresses, :state_id
  end
end
