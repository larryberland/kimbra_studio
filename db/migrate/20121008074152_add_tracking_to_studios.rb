class AddTrackingToStudios < ActiveRecord::Migration

  def change
    add_column :studios, :sales_status, :string, default: 'none'
    add_column :studios, :sales_notes, :text
    add_column :studios, :eap_click, :datetime
  end

end