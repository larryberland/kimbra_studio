# encoding: utf-8

class StockUploader < BaseUploader

  # Create different versions of your uploaded files:
  # let the model manipulate the image
  process :model_process   # model should implement this method => "#{mounted_as}_process"
  process :convert => 'png'
  process :store_geometry  # do after crop so we store current geometry

  version :thumb do
     process :resize_to_limit => [100, 100]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # Add a white list of extensions whih are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

end
