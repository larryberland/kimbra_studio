class CreateShippingOptions < ActiveRecord::Migration

  def change
    create_table :shipping_options, :force => true do |f|
      f.string :name
      f.string :description
      f.integer :cost_cents
      f.integer :sort_order
      f.timestamps
    end
  end

end