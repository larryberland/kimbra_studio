class CreateMyStudioClients < ActiveRecord::Migration
  def change
    create_table :my_studio_clients do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.boolean :active, :default => true
      t.references :address

      t.timestamps
    end
    add_index :my_studio_clients, :address_id
  end
end
