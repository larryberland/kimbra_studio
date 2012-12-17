class AddXmsTrackingToStudios < ActiveRecord::Migration

  def change
    add_column :studios, :xms_click, :datetime
  end

end