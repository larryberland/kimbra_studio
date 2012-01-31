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
    #puts "cp=>#{storage.path}"
    if file.kind_of?(CarrierWave::SanitizedFile)
      puts "using storage file"
      Magick::Image.read(current_path).first
    else
      puts "using storage fog"
      p = model.send("#{mounted_as}_url", version)
      Magick::Image.read(p).first
    end

    #image = if storage.kind_of?(CarrierWave::Storage::File)
    #else
    #  s = send("#{mounted_as}_url")
    #  Magick::Image.read(storage.file)
    #end
    #image.first
  end

end
