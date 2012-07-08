# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  storage KIMBRA_STUDIO_CONFIG[:carrier_wave][:storage]

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    version = version_name.downcase if version_name
    du = "/images/fallback/" + [version, "empty_deal_image.png"].compact.join('_')
    # puts "default_url=>#{du}"
    du
  end

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

  # returns a Magick Image from the current carrierwave file
  #   could be fog or local file?
  def to_image(version=nil)
    img = if file.kind_of?(CarrierWave::SanitizedFile)
              # puts "using storage file"
              Magick::Image.read(current_path)
          else
            # fog file?
              #puts "#{model.class.name} for #{mounted_as} version=>#{version}"
              p = model.send("#{mounted_as}_url", version)
              raise "#{model.class.name} for #{mounted_as} using amazon file#{p}" if p.blank?
              Magick::Image.read(p)
            end
    img.first
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end

end