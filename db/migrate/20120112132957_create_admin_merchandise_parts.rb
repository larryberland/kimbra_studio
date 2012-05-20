class CreateAdminMerchandiseParts < ActiveRecord::Migration
  def change
    create_table :admin_merchandise_parts do |t|
      t.references :piece
      t.references :portrait
      t.string :image_part
      t.string :image
      t.integer :order, :default => 0
      t.boolean :photo, :default => true
      t.integer :image_width
      t.integer :image_height
      t.integer :image_part_width
      t.integer :image_part_height
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :admin_merchandise_parts, :piece_id
    add_index :admin_merchandise_parts, :portrait_id
  end
end
