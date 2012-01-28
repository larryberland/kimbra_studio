# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  puts "setting storage=>#{KIMBRA_STUDIO_CONFIG[:carrier_wave][:storage]}"
  storage KIMBRA_STUDIO_CONFIG[:carrier_wave][:storage]

end
