class CreateAdminMerchandisePieces < ActiveRecord::Migration
  def change
    create_table :admin_merchandise_pieces do |t|
      t.string :category
      t.string :name
      t.string :image
      t.string :short_description
      t.text   :description_markup
      t.string :sku
      t.decimal :price
      t.string  :custom_layout, :default => 'order'
      t.integer :width, :default => 0
      t.integer :height, :default => 0
      t.boolean :active, :default => true
      t.boolean :featured
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :admin_merchandise_pieces, [:name, :category], :unique => true

  end
end
