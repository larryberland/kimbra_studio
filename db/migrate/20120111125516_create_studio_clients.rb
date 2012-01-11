class CreateStudioClients < ActiveRecord::Migration
  def change
    create_table :studio_clients do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.boolean :active
      t.references :address

      t.timestamps
    end
    add_index :studio_clients, :address_id
  end
end
