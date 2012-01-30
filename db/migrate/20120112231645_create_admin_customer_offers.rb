class CreateAdminCustomerOffers < ActiveRecord::Migration
  def change
    create_table :admin_customer_offers do |t|
      t.references :email
      t.references :piece

      t.string :image
      t.string :image_front
      t.string :image_back
      t.boolean :active, :default => true
      t.string :name           # from merchandise/piece.name
      t.text :description      # from merchandise/piece.short_description

      t.string :custom_layout, :default => 'order'

      t.string :activation_code
      t.datetime :visited_at   # customer visited mini-site offer
      t.datetime :purchased_at # customer purchased item

      t.integer :width         # width of portrait??
      t.integer :height        # height of portrait??
      t.timestamps
    end
    add_index :admin_customer_offers, :email_id
    add_index :admin_customer_offers, :piece_id
  end
end
