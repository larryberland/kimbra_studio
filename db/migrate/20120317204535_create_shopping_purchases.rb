class CreateShoppingPurchases < ActiveRecord::Migration
  def change
    create_table :shopping_purchases do |t|
      t.references :cart
      t.decimal :tax
      t.decimal :total

      t.timestamps
    end
    add_index :shopping_purchases, :cart_id
  end
end
