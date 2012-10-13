class CreatePicturesTable < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :avatar
      t.integer :width, :default => 0
      t.integer :height, :default => 0
      t.boolean :active, :default => true
      t.references :my_studio_session

      t.timestamps
    end
    add_index :pictures, :my_studio_session_id
  end
end
