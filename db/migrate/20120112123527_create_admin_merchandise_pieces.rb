class CreateAdminMerchandisePieces < ActiveRecord::Migration
  def change
    create_table :admin_merchandise_pieces do |t|
      t.string :name
      t.string :image
      t.string :short_description
      t.text   :description_markup
      t.string :sku
      t.decimal :price
      t.boolean :active
      t.boolean :featured
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
