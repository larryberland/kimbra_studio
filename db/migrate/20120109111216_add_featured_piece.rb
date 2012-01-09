class AddFeaturedPiece < ActiveRecord::Migration
  def up
    add_column :pieces, :featured, :boolean
    add_column :pieces, :deleted_at, :datetime

  end

  def down
    remove_column :pieces, :featured
    remove_column :pieces, :deleted_at
  end
end
