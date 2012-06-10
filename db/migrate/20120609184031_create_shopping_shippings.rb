class CreateShoppingShippings < ActiveRecord::Migration

  def change
    create_table :shopping_shippings do |t|
      t.references :cart
      t.string :shipping_option  # which shipping option was chosen
      t.integer :total_cents     # cost for chosen shipping option
      t.string :tracking         # tracking number or URL for the consumer to track.
      t.timestamps
    end
  end

end