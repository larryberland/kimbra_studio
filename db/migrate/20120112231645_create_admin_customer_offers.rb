class CreateAdminCustomerOffers < ActiveRecord::Migration
  def change
    create_table :admin_customer_offers do |t|
      t.string :name
      t.string :image
      t.text :description
      t.integer :x_pos
      t.integer :y_pos
      t.integer :width
      t.integer :height
      t.string :activation_code
      t.boolean :active, :default => true
      t.references :email
      t.references :piece
      t.references :studio_picture

      t.timestamps
    end
    add_index :admin_customer_offers, :email_id
    add_index :admin_customer_offers, :piece_id
    add_index :admin_customer_offers, :studio_picture_id
  end
end
