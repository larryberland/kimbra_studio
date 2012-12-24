class RemoveColumnShoppingItems < ActiveRecord::Migration
  def up
    remove_column :shopping_items, :from_piece
  end

  def down
    add_column :shopping_items, :from_piece, :boolean
  end
end
