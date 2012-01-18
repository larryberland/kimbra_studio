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
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :admin_merchandise_parts, :piece_id
    add_index :admin_merchandise_parts, :portrait_id
  end
end
