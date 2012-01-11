class RemoveFileNameFromStudioPictures < ActiveRecord::Migration
  def up
    remove_column :studio_pictures, :file_name
  end

  def down
    add_column :studio_pictures, :file_name, :string
  end
end
