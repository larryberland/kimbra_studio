class CreateShoppingCarts < ActiveRecord::Migration
  def change
    create_table :shopping_carts do |t|
      t.references :email
      t.string :tracking
      t.timestamps
    end
    add_index :shopping_carts, :email_id
  end
end
