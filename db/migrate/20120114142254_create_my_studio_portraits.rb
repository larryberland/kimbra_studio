class CreateMyStudioPortraits < ActiveRecord::Migration
  def change
    create_table :my_studio_portraits do |t|
      t.string :image
      t.string :description
      t.boolean :active, :default => true
      t.references :my_studio_session

      t.timestamps
    end
    add_index :my_studio_portraits, :my_studio_session_id
  end
end
