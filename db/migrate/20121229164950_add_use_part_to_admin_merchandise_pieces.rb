class AddUsePartToAdminMerchandisePieces < ActiveRecord::Migration
  def change
    add_column :admin_merchandise_pieces, :use_part_image, :boolean
  end
end
