class AddCommissionToMyStudioInfos < ActiveRecord::Migration

  def change
    add_column :my_studio_infos, :commission_rate, :integer, :default => 0  # commission percentage, 15 = 15%
  end

end