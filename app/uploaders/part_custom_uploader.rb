# encoding: utf-8

class PartCustomUploader < BaseUploader


  # Create different versions of your uploaded files:
  process :model_process    # model should implement this method => "#{mounted_as}_process"
  process :convert => 'jpg'

  version :thumb do
     process :resize_to_limit => [100, 100]
  end

  version :list do
     process :resize_to_limit => [200, 200]
  end

  # Add a white list of extensions whih are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

end
