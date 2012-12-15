class AddNameToMyStudioMinisite < ActiveRecord::Migration
  def change
    add_column :my_studio_minisites, :name, :string, limit: 20
  end
end
