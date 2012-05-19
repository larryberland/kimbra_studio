# encoding: utf-8

class StockUploader < BaseUploader

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

  # Create different versions of your uploaded files:
  process :store_geometry  # do we do this before crop or after
  process :model_process   # let the model manipulate the image
  process :convert => 'jpg'
  process :center_in_area

  def crop
    if model.cropping?
      puts "#{self} is cropping"
      #resize_to_limit(300, 300)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop(x, y, w, h)
      end
    end
  end

  version :thumb do
     process :resize_to_limit => [100, 100]
  end

  version :croppable do
    process :crop
    resize_to_fill(300, 300)
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
