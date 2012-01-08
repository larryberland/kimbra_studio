class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.string :name
      t.string :short_description
      t.string :long_description
      t.string :sku
      t.decimal :price, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.boolean :active

      t.timestamps
    end
  end
end
