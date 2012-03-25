class CreateShoppingPurchases < ActiveRecord::Migration
  def change
    create_table :shopping_purchases do |t|
      t.references :cart
      t.decimal :tax
      t.decimal :total
      t.string :stripe_card_token
      t.string :stripe_response_id
      t.string :stripe_paid
      t.string :stripe_fee
      t.integer :total_cents
      t.datetime :purchased_at

      t.timestamps
    end
    add_index :shopping_purchases, :cart_id
  end
end
