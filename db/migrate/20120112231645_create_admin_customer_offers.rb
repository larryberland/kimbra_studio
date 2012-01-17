class CreateAdminCustomerOffers < ActiveRecord::Migration
  def change
    create_table :admin_customer_offers do |t|
      t.references :email
      t.references :piece
      t.references :portrait
      t.boolean :active, :default => true
      t.string :name
      t.text :description
      t.string :image
      t.string :activation_code
      t.datetime :visited_at # customer visited mini-site offer
      t.datetime :purchased_at # customer purchased item
      t.integer :x_pos
      t.integer :y_pos
      t.integer :width
      t.integer :height
      t.timestamps
    end
    add_index :admin_customer_offers, :email_id
    add_index :admin_customer_offers, :piece_id
    add_index :admin_customer_offers, :portrait_id
  end
end
