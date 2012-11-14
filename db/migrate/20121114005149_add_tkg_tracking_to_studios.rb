class AddTkgTrackingToStudios < ActiveRecord::Migration

  def change
    add_column :studios, :tkg_click, :datetime
  end

end