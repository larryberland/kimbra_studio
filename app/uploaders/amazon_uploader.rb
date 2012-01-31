# encoding: utf-8

class AmazonUploader < BaseUploader

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  storage :fog  # always use fog for this

  # store the width and height into model
  process :store_geometry

  # Create different versions of your uploaded files:
  version :thumb do
     process :resize_to_limit => [100, 100]
  end

  version :list do
     process :resize_to_limit => [50, 50]
  end

  version :face do
    process :convert => 'jpg'
    process :resize_to_limit => [900, 900]
  end

  #version :best do
  #  process :convert => 'jpg'
  #  process :store_best_geometry
  #end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
