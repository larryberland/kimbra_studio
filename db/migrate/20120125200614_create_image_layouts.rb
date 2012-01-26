class CreateImageLayouts < ActiveRecord::Migration
  def change
    create_table :image_layouts do |t|
      t.string :layout_type
      t.integer :layout_id
      t.integer :x
      t.integer :y
      t.integer :w
      t.integer :h
      t.decimal :degrees

      t.timestamps
    end
  end
end
