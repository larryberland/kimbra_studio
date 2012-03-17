class CreateShoppingCarts < ActiveRecord::Migration
  def change
    create_table :shopping_carts do |t|
      t.references :showroom

      t.timestamps
    end
    add_index :shopping_carts, :showroom_id
  end
end
