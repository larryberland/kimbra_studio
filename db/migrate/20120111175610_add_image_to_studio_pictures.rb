class AddImageToStudioPictures < ActiveRecord::Migration
  def change
    add_column :studio_pictures, :image, :string
  end
end
