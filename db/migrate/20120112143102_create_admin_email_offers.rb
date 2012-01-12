class CreateAdminEmailOffers < ActiveRecord::Migration
  def change
    create_table :admin_email_offers do |t|
      t.string :name
      t.string :image
      t.text :description
      t.integer :x_pos
      t.integer :y_pos
      t.integer :width
      t.integer :height
      t.string :activation_code
      t.boolean :active
      t.references :piece
      t.references :studio_picture
      t.references :email

      t.timestamps
    end
    add_index :admin_email_offers, :piece_id
    add_index :admin_email_offers, :studio_picture_id
  end
end
