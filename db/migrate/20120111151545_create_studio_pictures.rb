class CreateStudioPictures < ActiveRecord::Migration
  def change
    create_table :studio_pictures do |t|
      t.string :description
      t.string :image
      t.boolean :active
      t.references :shoot

      t.timestamps
    end
    add_index :studio_pictures, :shoot_id
  end
end
