puts "pulling in #{__FILE__}"
# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  puts "setting storage=>#{KIMBRA_STUDIO_CONFIG[:carrier_wave][:storage]}"
  storage KIMBRA_STUDIO_CONFIG[:carrier_wave][:storage]

  # helper method to store image from a full_path filename
  def store_file!(full_path_filename)
    store!(File.open(full_path_filename))
  end

  def store_image!(rmagick_image)
    t_file = Tempfile.new(["#{mounted_as}", '.jpg'])
    rmagick_image.write(t_file.path)
    store_file!(t_file.path)
    t_file
  end

  def to_image(version=nil)
    image = if file.kind_of?(CarrierWave::SanitizedFile)
              puts "using storage file"
              Magick::Image.read(current_path)
            else
              p = model.send("#{mounted_as}_url", version)
              puts "#{model.class.name} for #{mounted_as} using amazon file#{p}"
              raise "#{model.class.name} for #{mounted_as} using amazon file#{p}" if p.blank?
              Magick::Image.read(p)
            end
    image.first
  end

  #def center_in_area(img, dest_width, dest_height)
  #  w = img.columns
  #  h = img.rows
  #  x = (dest_width - w) / 2 if w < dest_width
  #  y = (dest_height - h) / 2 if h < dest_height
  #  if x or y
  #    x         ||= 0
  #    y         ||= 0
  #    new_image = image_new(dest_width, dest_height).composite(img, x, y, Magick::AtopCompositeOp)
  #  end
  #  new_image ||= img
  #  new_image
  #end

end
