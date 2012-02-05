module CarrierWave
  module RMagick

    def store_geometry
      manipulate! do |img|
        if model
          puts "store geometry #{model} #{img.columns}x#{img.rows}"
          model.send('width=', img.columns) if model.respond_to?(:width)
          model.send('height=', img.rows) if model.respond_to?(:height)
        end
        img = yield(img) if block_given?
        img
      end
    end

    # let the model do processing on the original image
    def model_process
      manipulate! do |img|
        if model
          m = "#{mounted_as}_process"
          img = model.send(m, img) if model.respond_to?(m) if model.respond_to?(m)
        end
        img = yield(img) if block_given?
        img
      end
    end

    #noinspection RubyArgCount
    def center_in_area
      manipulate! do |img|
        w = img.columns
        h = img.rows
        if model
          dest_width, dest_height = model.send(:get_dest_area)
          x = (dest_width - w) / 2 if w < dest_width
          y = (dest_height - h) / 2 if h < dest_height
          if x or y
            x         ||= 0
            y         ||= 0
            img = Magick::Image.new(dest_width, dest_height).composite(img, x, y, Magick::AtopCompositeOp)
          end
        end
        img = yield(img) if block_given?
        img
      end
    end

  end
end