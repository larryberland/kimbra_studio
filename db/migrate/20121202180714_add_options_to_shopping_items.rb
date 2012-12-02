class AddOptionsToShoppingItems < ActiveRecord::Migration
  def change
    add_column :shopping_items, :option, :string
    add_column :shopping_items, :option_selected, :string
  end
end
