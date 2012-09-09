class AddDefaultCommission < ActiveRecord::Migration

  def up
    change_column :my_studio_infos, :commission_rate, :integer, default: 15
  end

  def down
  end

end