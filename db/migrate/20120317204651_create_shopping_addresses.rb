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

      t.timestamps
    end
    add_index :shopping_addresses, :state_id
  end
end
