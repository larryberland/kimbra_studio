class AddLayoutPiece < ActiveRecord::Migration
  def change
    create_table :piece_layouts do |t|
      t.references :part
      t.timestamps
    end
    add_index :piece_layouts, :part_id

    create_table :part_layouts do |t|
      t.references :part
      t.timestamps
    end
    add_index :part_layouts, :part_id
  end
end
