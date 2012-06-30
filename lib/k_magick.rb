puts "pulling in #{__FILE__}"
module KMagick

  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def dump_dir
      @dump_dir ||= self.name.split('::').join('_').downcase
    end

    def dump_name
      @dump_name ||= self.name.split('::').last.downcase
    end
  end

  module InstanceMethods
    private

    # wrapper to avoid the api problem
    #noinspection RubyArgCount
    def image_new(width, height)
      Magick::Image.new(width, height)
    end

    def image_transparent(width, height)
      Magick::Image.new(width, height) {
        self.background_color = "transparent";
      }
    end

    # wrapper around image processing so the image
    #  will be written to a temp file for anlaysis
    #  or loading by another Uploader
    def create_image_temp(base_filename='resize')
      # raise "do i need this"
      t_temp = Tempfile.new([base_filename, '.jpg'])
      img = yield; img.write(t_temp.path) if block_given?
      return img, t_temp
    end

    # save the current rmagick_image into a temp file
    #  so the carrier_wave uploader will save this image
    def save_image!(rmagick_image, model_image_attr, tmp_filename='custom')
      t_custom = Tempfile.new([tmp_filename, '.jpg'])
      rmagick_image.write(t_custom.path)
      model_image_attr.store!(File.open(t_custom.path))
      send("write_#{model_image_attr.mounted_as}_identifier")
      save # pretty sure we need to save the model
      t_custom
    end

    # save file in full_path to the CarrierWave uploader
    def set_from_file(model_image_attr, full_path)
      model_image_attr.store!(File.open(full_path))
      send("write_#{model_image_attr.mounted_as}_identifier")
      model_image_attr
    end

    # save carrier_wave url to the CarrierWave uploader
    def set_from_url(model_image_attr, carrier_wave_url)
      model_image_attr.store!(carrier_wave_url)
      send("write_#{model_image_attr.mounted_as}_identifier")
      model_image_attr
    end

    #noinspection RubyArgCount
    def path(dir)
      #p = Rails.root.join('public', 'kmagick', self.class.dump_dir, dir)
      # mkpath does not seem to be working on heroku. use tmp to see if that works.
      p = Rails.root.join('tmp', self.class.dump_dir, dir)
      p.mkpath unless File.exists?(p.to_s)
      p

    end

    def dump(dir, img, filename=nil)
      if KIMBRA_STUDIO_CONFIG[:dump_image] and img
        if filename.nil?
          filename = send(:dump_filename) if respond_to?(:dump_filename)
          filename ||= "#{self.class.dump_name}_#{id}.jpg"
        end
        puts "dump file=>#{dir}/#{filename}"
        img.write(path(dir).join(filename).to_s)
      end
    end

  end

end