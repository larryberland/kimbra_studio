class ReferenceStudio < ActiveRecord::Migration
  def up
    change_table(:info_studios) do |t|
      t.references :studio
    end
    change_table(:mini_site_studios) do |t|
      t.references :studio
    end
    change_table(:users) do |t|
      t.references :studio
    end
  end

  def down
    remove_column :info_studios, :studio_id
    remove_column :mini_site_studios, :studio_id
    remove_column :users, :studio_id
  end
end
