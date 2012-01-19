class CreateAdminMerchandiseParts < ActiveRecord::Migration
  def change
    create_table :admin_merchandise_parts do |t|
      t.references :piece
      t.references :portrait
      t.string :image_part
      t.string :image
      t.integer :order
      t.integer :width
      t.integer :height
      t.integer :item_x,      :default => 80
      t.integer :item_y,      :default => 80
      t.integer :item_width,  :default => 245
      t.integer :item_height, :default => 290
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :admin_merchandise_parts, :piece_id
    add_index :admin_merchandise_parts, :portrait_id
  end
end
