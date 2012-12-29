class CheckboxForPinterest < ActiveRecord::Migration

  def change
    add_column :my_studio_infos, :pinterest_for_clients, :boolean, default: true
  end

end