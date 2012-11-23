class AddPhotoToAdminMerchandisePieces < ActiveRecord::Migration
  def change
    add_column :admin_merchandise_pieces, :photo, :boolean
  end
end
