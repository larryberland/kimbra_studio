class AddFromPieceToShoppingItems < ActiveRecord::Migration
  def change
    add_column :shopping_items, :from_piece, :boolean, default: false
  end
end
