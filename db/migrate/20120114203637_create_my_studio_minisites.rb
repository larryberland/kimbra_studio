class CreateMyStudioMinisites < ActiveRecord::Migration
  def change
    create_table :my_studio_minisites do |t|
      t.references :studio
      t.string :bgcolor
      t.string :image
      t.string :font_family
      t.string :font_color
      t.string :theme

      t.timestamps
    end
    add_index :my_studio_minisites, :studio_id
  end
end
