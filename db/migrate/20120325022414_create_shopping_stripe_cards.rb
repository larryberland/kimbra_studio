class CreateShoppingStripeCards < ActiveRecord::Migration
  def change
    create_table :shopping_stripe_cards do |t|
      t.references :purchase
      t.string :country
      t.string :cvc_check
      t.integer :exp_month
      t.integer :exp_year
      t.string :last4
      t.string :stripe_type
      t.string :stripe_object

      t.timestamps
    end
    add_index :shopping_stripe_cards, :purchase_id
  end
end
