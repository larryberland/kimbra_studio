class CreateImageLayouts < ActiveRecord::Migration
  def change
    create_table :image_layouts do |t|
      t.string :type
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height
      t.decimal :rotation

      t.timestamps
    end
  end
end
