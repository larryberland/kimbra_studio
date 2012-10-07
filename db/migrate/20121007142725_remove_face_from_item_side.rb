class RemoveFaceFromItemSide < ActiveRecord::Migration
  def change
    remove_column :admin_customer_item_sides, :face_id
  end
end
