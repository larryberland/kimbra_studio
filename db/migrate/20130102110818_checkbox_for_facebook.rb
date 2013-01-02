class CheckboxForFacebook < ActiveRecord::Migration

  def change
    add_column :my_studio_infos, :facebook_for_clients, :boolean, default: true
  end

end