class CreateStudioShoots < ActiveRecord::Migration
  def change
    create_table :studio_shoots do |t|
      t.string :name
      t.datetime :date
      t.references :studio
      t.references :client
      t.references :category

      t.timestamps
    end
    add_index :studio_shoots, :studio_id
    add_index :studio_shoots, :client_id
    add_index :studio_shoots, :category_id
  end
end
