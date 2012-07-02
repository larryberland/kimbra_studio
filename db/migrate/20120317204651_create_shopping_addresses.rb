class CreateShoppingAddresses < ActiveRecord::Migration
  def change
    create_table :shopping_addresses do |t|
      t.references :cart
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.references :state
      t.string :zip_code
      t.string :country, default: 'USA'
      t.string :email
      t.string :phone

      t.timestamps
    end
    add_index :shopping_addresses, :state_id
    add_index :shopping_addresses, :phone
  end
end
