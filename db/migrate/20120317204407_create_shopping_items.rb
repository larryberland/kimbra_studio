class CreateShoppingItems < ActiveRecord::Migration
  def change
    create_table :shopping_items do |t|
      t.references :cart
      t.references :offer
      t.integer :quantity

      t.timestamps
    end
    add_index :shopping_items, :cart_id
    add_index :shopping_items, :offer_id
  end
end
