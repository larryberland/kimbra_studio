class AddSizeToMyStudioMinisite < ActiveRecord::Migration
  def change
    add_column :my_studio_minisites, :image_width, :integer
    add_column :my_studio_minisites, :image_height, :integer
  end
end
